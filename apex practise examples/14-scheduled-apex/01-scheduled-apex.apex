/**
 * 14 - SCHEDULED APEX - Comprehensive Scheduling Examples
 * Schedulable interface, cron expressions, job management
 */

// ========== BASIC SCHEDULED CLASS ==========
public class BasicScheduledJob implements Schedulable {
    
    public void execute(SchedulableContext sc) {
        // Job logic
        List<Account> accounts = [
            SELECT Id, Name, LastModifiedDate
            FROM Account
            WHERE LastModifiedDate < LAST_N_DAYS:30
        ];
        
        for (Account acc : accounts) {
            acc.Description = 'Reviewed on ' + Date.today();
        }
        
        update accounts;
    }
}

// Schedule: System.schedule('Daily Account Review', '0 0 2 * * ?', new BasicScheduledJob());

// ========== CRON EXPRESSIONS ==========
public class CronExpressionExamples {
    
    public static void scheduleDailyMidnight() {
        // Run daily at midnight
        String cronExp = '0 0 0 * * ?';
        System.schedule('Daily Midnight', cronExp, new BasicScheduledJob());
    }
    
    public static void scheduleHourly() {
        // Run every hour
        String cronExp = '0 0 * * * ?';
        System.schedule('Hourly Job', cronExp, new BasicScheduledJob());
    }
    
    public static void scheduleWeekdays9AM() {
        // Run weekdays at 9 AM
        String cronExp = '0 0 9 ? * MON-FRI';
        System.schedule('Weekday Morning', cronExp, new BasicScheduledJob());
    }
    
    public static void scheduleMonthly() {
        // Run 1st day of month at 6 AM
        String cronExp = '0 0 6 1 * ?';
        System.schedule('Monthly Job', cronExp, new BasicScheduledJob());
    }
    
    public static void scheduleEvery15Minutes() {
        // Run every 15 minutes
        String cronExp = '0 0,15,30,45 * * * ?';
        System.schedule('Every 15 Min', cronExp, new BasicScheduledJob());
    }
}

/* CRON FORMAT: Seconds Minutes Hours Day_of_month Month Day_of_week Optional_year
Examples:
0 0 0 * * ?        - Daily at midnight
0 0 12 * * ?       - Daily at noon
0 0 8-17 * * ?     - Every hour from 8am-5pm
0 0 0 ? * MON      - Every Monday at midnight
0 0 0 1 * ?        - 1st of month at midnight
0 0 0 L * ?        - Last day of month
0 0 0 ? * 2#1      - First Monday of month
*/

// ========== SCHEDULED BATCH JOB ==========
public class ScheduledBatchJob implements Schedulable {
    
    public void execute(SchedulableContext sc) {
        // Execute batch job
        Database.executeBatch(new AccountBatchJob(), 200);
    }
}

// Account Batch
public class AccountBatchJob implements Database.Batchable<sObject> {
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT Id, Name, Industry
            FROM Account
        ]);
    }
    
    public void execute(Database.BatchableContext bc, List<Account> scope) {
        for (Account acc : scope) {
            acc.Description = 'Batch processed';
        }
        update scope;
    }
    
    public void finish(Database.BatchableContext bc) {
        System.debug('Scheduled batch completed');
    }
}

// ========== SCHEDULED WITH PARAMETERS ==========
public class ScheduledWithParams implements Schedulable {
    
    private String industry;
    private Integer daysOld;
    
    public ScheduledWithParams(String ind, Integer days) {
        this.industry = ind;
        this.daysOld = days;
    }
    
    public void execute(SchedulableContext sc) {
        String query = 'SELECT Id FROM Account WHERE Industry = :industry ' +
                      'AND CreatedDate < LAST_N_DAYS:' + daysOld;
        
        List<Account> accounts = Database.query(query);
        
        for (Account acc : accounts) {
            acc.Description = 'Old account';
        }
        
        update accounts;
    }
}

// Schedule: System.schedule('Tech Review', '0 0 1 * * ?', new ScheduledWithParams('Technology', 90));

// ========== SELF-RESCHEDULING JOB ==========
public class SelfReschedulingJob implements Schedulable {
    
    public void execute(SchedulableContext sc) {
        // Do work
        List<Account> accounts = [SELECT Id FROM Account LIMIT 100];
        // Process accounts...
        
        // Abort current job
        System.abortJob(sc.getTriggerId());
        
        // Reschedule for next hour
        String cronExp = '0 0 ' + (DateTime.now().hour() + 1) + ' * * ?';
        System.schedule('Self Reschedule', cronExp, new SelfReschedulingJob());
    }
}

// ========== SCHEDULED JOB MANAGER ==========
public class ScheduledJobManager {
    
    // Schedule multiple jobs
    public static void scheduleAllJobs() {
        // Daily cleanup at 1 AM
        System.schedule(
            'Daily Cleanup',
            '0 0 1 * * ?',
            new DailyCleanupJob()
        );
        
        // Hourly sync
        System.schedule(
            'Hourly Sync',
            '0 0 * * * ?',
            new HourlySyncJob()
        );
        
        // Weekly report on Sunday at 8 AM
        System.schedule(
            'Weekly Report',
            '0 0 8 ? * SUN',
            new WeeklyReportJob()
        );
    }
    
    // Abort all scheduled jobs
    public static void abortAllJobs() {
        List<CronTrigger> jobs = [
            SELECT Id, CronJobDetail.Name
            FROM CronTrigger
            WHERE CronJobDetail.Name LIKE '%Custom%'
        ];
        
        for (CronTrigger job : jobs) {
            System.abortJob(job.Id);
        }
    }
    
    // Get job status
    public static void checkJobStatus(String jobName) {
        List<CronTrigger> jobs = [
            SELECT Id, CronExpression, TimesTriggered, NextFireTime,
                   State, CronJobDetail.Name
            FROM CronTrigger
            WHERE CronJobDetail.Name = :jobName
        ];
        
        for (CronTrigger job : jobs) {
            System.debug('Job: ' + job.CronJobDetail.Name);
            System.debug('Next Run: ' + job.NextFireTime);
            System.debug('Times Run: ' + job.TimesTriggered);
            System.debug('State: ' + job.State);
        }
    }
}

// ========== SCHEDULED WITH CALLOUTS ==========
public class ScheduledCallout implements Schedulable {
    
    public void execute(SchedulableContext sc) {
        // Make HTTP callout
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.example.com/data');
        req.setMethod('GET');
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        if (res.getStatusCode() == 200) {
            // Process response
            String body = res.getBody();
            // Update Salesforce records
        }
    }
}

// ========== COMPLEX SCHEDULED JOB ==========
public class ComplexScheduledJob implements Schedulable {
    
    public void execute(SchedulableContext sc) {
        // Get job info
        CronTrigger ct = [
            SELECT Id, CronExpression, TimesTriggered, NextFireTime
            FROM CronTrigger
            WHERE Id = :sc.getTriggerId()
        ];
        
        System.debug('Job triggered ' + ct.TimesTriggered + ' times');
        System.debug('Next run: ' + ct.NextFireTime);
        
        // Conditional logic based on day
        if (Date.today().day() == 1) {
            // Monthly processing
            processMonthlyReports();
        } else {
            // Daily processing
            processDailyTasks();
        }
    }
    
    private void processMonthlyReports() {
        // Monthly logic
    }
    
    private void processDailyTasks() {
        // Daily logic
    }
}

// ========== SCHEDULED JOB BEST PRACTICES ==========
public class ScheduledBestPractices implements Schedulable {
    
    public void execute(SchedulableContext sc) {
        try {
            // Check if already running
            if (isJobAlreadyRunning()) {
                System.debug('Job already running, skipping...');
                return;
            }
            
            // Process in manageable chunks
            Integer batchSize = 200;
            List<Account> accounts = [
                SELECT Id, Name
                FROM Account
                WHERE LastModifiedDate = TODAY
                LIMIT :batchSize
            ];
            
            if (accounts.isEmpty()) {
                System.debug('No records to process');
                return;
            }
            
            // Process records
            for (Account acc : accounts) {
                acc.Description = 'Scheduled update';
            }
            
            Database.SaveResult[] results = Database.update(accounts, false);
            
            // Handle errors
            Integer errorCount = 0;
            for (Database.SaveResult result : results) {
                if (!result.isSuccess()) {
                    errorCount++;
                }
            }
            
            System.debug('Processed ' + accounts.size() + ' records');
            System.debug('Errors: ' + errorCount);
            
            // Send notification if errors
            if (errorCount > 0) {
                sendErrorNotification(errorCount);
            }
            
        } catch (Exception e) {
            System.debug('Scheduled job error: ' + e.getMessage());
            
            // Log error
            logError(sc.getTriggerId(), e);
            
            // Send alert
            sendErrorNotification(1);
        }
    }
    
    private Boolean isJobAlreadyRunning() {
        // Check AsyncApexJob for running instances
        Integer runningJobs = [
            SELECT COUNT()
            FROM AsyncApexJob
            WHERE JobType = 'ScheduledApex'
            AND Status IN ('Processing', 'Preparing')
            AND ApexClass.Name = 'ScheduledBestPractices'
        ];
        return runningJobs > 0;
    }
    
    private void sendErrorNotification(Integer errorCount) {
        // Send email
    }
    
    private void logError(String jobId, Exception e) {
        // Create error log record
    }
}

// ========== TESTING SCHEDULED APEX ==========
@isTest
private class ScheduledApexTest {
    
    @testSetup
    static void setup() {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 100; i++) {
            accounts.add(new Account(Name = 'Test ' + i));
        }
        insert accounts;
    }
    
    @isTest
    static void testScheduledJob() {
        String cronExp = '0 0 0 * * ?';
        
        Test.startTest();
        String jobId = System.schedule('Test Job', cronExp, new BasicScheduledJob());
        Test.stopTest();
        
        // Verify job was scheduled
        System.assertNotEquals(null, jobId);
        
        CronTrigger ct = [
            SELECT Id, CronExpression, TimesTriggered
            FROM CronTrigger
            WHERE Id = :jobId
        ];
        
        System.assertEquals(cronExp, ct.CronExpression);
    }
    
    @isTest
    static void testScheduledWithAbort() {
        String jobId = System.schedule('Test', '0 0 0 * * ?', new BasicScheduledJob());
        
        Test.startTest();
        System.abortJob(jobId);
        Test.stopTest();
        
        // Verify job was aborted
        List<CronTrigger> jobs = [SELECT Id FROM CronTrigger WHERE Id = :jobId];
        System.assertEquals(0, jobs.size());
    }
}

/* SCHEDULED APEX LIMITS:
- Max 100 scheduled jobs per org
- Cannot schedule more frequently than hourly
- Apex gov limits apply per execute() call
- Use batch for large data volumes

MONITORING:
Setup -> Scheduled Jobs
Setup -> Apex Jobs

ABOR TING:
System.abortJob(jobId);

BEST PRACTICES:
- Use batch apex for > 200 records
- Handle exceptions
- Check if job already running
- Log execution details
- Send error notifications
*/

/* PROGRAMMATIC SCHEDULING:
String cronExp = '0 0 1 * * ?';  // 1 AM daily
String jobId = System.schedule('My Job Name', cronExp, new MyScheduledClass());

// Get job ID from Dev Console/Anonymous Apex
// Or query CronTrigger
*/
