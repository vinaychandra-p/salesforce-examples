/**
 * 03 - Static vs Instance Members
 * Demonstrates: Static fields, static methods, instance members
 */

public class StaticExample {
    // Static variable (shared across all instances)
    private static Integer instanceCount = 0;
    
    // Instance variable (unique to each instance)
    private Integer instanceId;
    
    // Static block (executes once when class is loaded)
    static {
        System.debug('StaticExample class loaded');
        instanceCount = 0;
    }
    
    // Constructor
    public StaticExample() {
        instanceCount++;
        this.instanceId = instanceCount;
    }
    
    // Static method (can't access instance members)
    public static Integer getInstanceCount() {
        return instanceCount;
    }
    
    // Instance method (can access both static and instance members)
    public Integer getInstanceId() {
        return this.instanceId;
    }
    
    public String getInfo() {
        return 'Instance ' + instanceId + ' of ' + instanceCount + ' total';
    }
}

/* USAGE EXAMPLE:
System.debug(StaticExample.getInstanceCount()); // 0

StaticExample obj1 = new StaticExample();
StaticExample obj2 = new StaticExample();
StaticExample obj3 = new StaticExample();

System.debug(StaticExample.getInstanceCount()); // 3
System.debug(obj1.getInfo()); // Instance 1 of 3 total
System.debug(obj2.getInfo()); // Instance 2 of 3 total
System.debug(obj3.getInfo()); // Instance 3 of 3 total
*/
