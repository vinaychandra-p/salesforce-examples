/**
 * 06 - Comments and Documentation
 * Demonstrates: Single-line, multi-line, Javadoc comments
 */

/**
 * @description This class demonstrates proper commenting practices in Apex
 * @author Your Name
 * @date 2025-11-30
 * @group Fundamentals
 */
public class CommentsExample {
    
    // Single-line comment
    private String name;
    
    /*
     * Multi-line comment
     * Used for longer explanations
     * Can span multiple lines
     */
    private Integer count;
    
    /**
     * @description Constructor with parameters
     * @param name The name to set
     * @param count The initial count
     */
    public CommentsExample(String name, Integer count) {
        this.name = name;
        this.count = count;
    }
    
    /**
     * @description Increments the count by specified amount
     * @param amount The amount to increment
     * @return The new count value
     * @example
     * CommentsExample ex = new CommentsExample('Test', 5);
     * Integer newCount = ex.increment(3); // returns 8
     */
    public Integer increment(Integer amount) {
        // Input validation
        if (amount < 0) {
            throw new IllegalArgumentException('Amount must be positive');
        }
        
        this.count += amount; // Add amount to count
        return this.count;    // Return new value
    }
    
    /**
     * @description Gets the current count
     * @return Current count value
     */
    public Integer getCount() {
        return this.count;
    }
}

/* USAGE EXAMPLE:
CommentsExample ex = new CommentsExample('Test', 10);
System.debug(ex.getCount()); // 10
ex.increment(5);
System.debug(ex.getCount()); // 15
*/
