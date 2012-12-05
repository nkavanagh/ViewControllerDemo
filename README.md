
# Building the app

1) File -> New Project -> Single View Application

2) Change to iPhone simulator.

3) Run it with empty view.

4) Open iPhone storyboard. Go over toolbar buttons and UI for storyboard. Navigator. Document outline. Content. Utilities.

5) Drop some controls on the view. Set placeholder text on a UITextField. Run the app.

6) Delete the UIView. Run the app. Note the message in the debug area.

7) Add a UITableViewController. Run the app.

8) Expand the document outline. Explain why it's often easier to use than the content area.

9) Switch to attributes inspector. Click on the UITableView. Static cells = "WYSIWYG". Dynamic Prototypes for re-usable cells, where you want them to look or function depending on what you're putting in them. Switch to static. Add two sections. Plain for lists with headings (e.g. Mail.app), grouped for, well groups (e.g. settings, calendar events). Keep it with grouped, one section, two cells.

10) Click on the first cell. Run through the styles, go through custom last. Leave it on basic. 

11) Import the icons for calendar and BU Today.

12) First cell BU Today, second cell Calendar. Run the app.

13) Run through cell accessories. Disclosure to indicate tapping the cell will bring you somewhere else. Detail to indicate tapping the cell will show a detail view, e.g. a contact record. Choose a disclosure, as we're not displaying detail views (both will be lists of other things).

14) Add a new UIViewController. Delete the UIView, replace with UIWebView.

15) Right click on BU Today cell. Triggered Segues -> Selection -> Push. Drag to the new view we just made. Run the app. Note the message in the debug area.

16) Editor -> Embed in -> Navigation Controller. Run the app. Note the title bar. Navigate to BU Today. Note the back button.

17) Set titles (Boston University, BU Today) for navigation items on both views. Run the app. Note the titles. Note the label on the back button. Set the "Back Button" for the main view to "Home". Run the app. Note the label on the back button.

18) Show identity inspector for BU Today view controller. Change Custom Class to BUViewController. Turn on the assistant editor.

Aside: .h files are headers, .m files are implementation. Think of headers as files that advertise what a class is all about, i.e. its public face (like a Facebook timeline). Implementation files are how a class gets things done (like a desk, sometimes clean, sometimes messy).

19) Right click on web view. Drag a referencing outlet into the header. Briefly explain what a property is.

20) Switch to normal editor and open implementation. @synthesize webView. In viewDidLoad, [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.bu.edu/today"]]]; Run the app. Note the viewport.

21) In attributes inspector for web view, change scaling. Run again. Note scaling. Zoom to content. Mention that BU Today's mobile version is coming soon.

22) Zoom out a bit in the storyboard view. Reposition BU Today up. Drag another UITableViewController in below it. Set the navigation item title to "Calendar". Add a segue from "Calendar" to this new view controller. Run it.

23) Go to attributes inspector for new table view. Explain that we're going to use dynamic prototypes. Prototype one cell. Style subtitle. Switch to identity inspector. We need to write code for this view, so we need a place to put it.

24) File -> New -> File. Objective-C class. BUCalendarTableViewController, subclass of UITableViewController. Save it, then set this as the class for the UITableViewController for the calendar view.

25) Opens implementation. Note viewDidLoad. Run through table view data source methods. Run the app. Explain why it is blank.

26) Add NSArray *_events; as an instance variable to the implementation file.

27) Add to viewDidLoad:

NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.bu.edu/bumobile/rpc/calendar/events.json.php?tid=51"]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            NSLog(@"There was a problem fetching the events: %@", error);
        } else if (data) {
            NSDictionary *decodedResponse = [NSJSONSerialization JSONObjectWithData:data
                                                                            options:NSJSONReadingMutableContainers
                                                                              error:nil];
            
            NSDictionary *resultSet = [decodedResponse objectForKey:@"ResultSet"];
            
            _events = [resultSet objectForKey:@"Result"];
            NSLog(@"Downloaded %d events: %@", [_events count], _events);
			
        } else {
            NSLog(@"There were no events!");
        }
    }];

Run the app. Note debug log.

28) Change numberOfSectionsInTableView to return one section.

29) Change numberOfRowsInSection to return the number of events.

30) - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EventCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    
    NSDictionary *event = [_events objectAtIndex:indexPath.row];
    cell.textLabel.text = [event objectForKey:@"summary"];
    cell.detailTextLabel.text = [event objectForKey:@"time"];
    
    return cell;
}

Run the app. Doesn't work! Add [self.tableView reloadData] to completion handler. Run again.

31) Drag in another UITableViewController for event detail. Grouped static cells, three sections. Two rows first section (summary and time), basic. One in second section (description), basic. Three in third section (location, phone, email), right detail. Change font on time and description to non-bold.

32) Right click on event cell prototype. Add a segue to event detail view. Change accessory to detail disclosure. Set navigation title for event detail ("Event"). Run the app. No data yet!

33) Add an implementation file for the detail view. Set the custom class on the view. Run the app. Explain why the view is blank, then remove the table data source methods. Run the app again.

34) Open up the assistant editor and add outlets for the detail view labels. Add @property NSNumber *eventID; @synthesize all the properties.

35) Give a name to the segue in attributes editor ("eventDetailSegue"). 

36) In implementation for calendar table view, add ivar NSIndexPath *selectedEvent;. Set it in didSelectRowAtIndexPath. Add:

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"eventDetailSegue"]) {
        NSDictionary *event = [_events objectAtIndex:selectedEvent.row];
        // Get reference to the destination view controller
        BUEventDetailTableViewController *vc = (BUEventDetailTableViewController *)[segue destinationViewController];
        [vc setEventID:[event objectForKey:@"id"]];
    }
}

37) Add to detail view:

- (void)viewDidAppear:(BOOL)animated
{
    NSString *uri = [NSString stringWithFormat:@"http://www.bu.edu/bumobile/rpc/calendar/events.json.php?eid=%@", eventID];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:uri]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            NSLog(@"There was a problem fetching the event: %@", error);
        } else if (data) {
            NSDictionary *decodedResponse = [NSJSONSerialization JSONObjectWithData:data
                                                                            options:NSJSONReadingMutableContainers
                                                                              error:nil];
            
            NSDictionary *resultSet = [decodedResponse objectForKey:@"ResultSet"];
            
            NSDictionary *event = [resultSet[@"Result"] firstObject];
            
            NSLog(@"event: %@", event);
            summaryLabel.text = event[@"summary"];
            timeLabel.text = [NSString stringWithFormat:@"%@; %@", event[@"displayTime"], event[@"displayDate"]];
            descriptionLabel.text = event[@"description"];
            locationLabel.text = event[@"location"];
            phoneLabel.text = event[@"phone"];
            emailLabel.text = event[@"contactEmail"];
            
        } else {
            NSLog(@"There was no event data!");
        }
    }];

    [super viewDidAppear:animated];
}

38) Open up some events. We're always getting the next-to-last event! Why?

39) Remove segue from table cell. On calendar view, triggered segue, manual, push to event detail. Set the identifier to eventDetailSegue. Run the app.

40) Add [self performSegueWithIdentifier:@"eventDetailSegue" sender:self]; to didSelectRowAtIndexPath. Run the app.

# What's missing

* Feedback during data loading. Caching. Error checking of all sorts.







