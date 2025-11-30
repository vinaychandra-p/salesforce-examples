/**
 * 09 - Enums (Enumerations)
 * Demonstrates: Enum declaration, usage, and methods
 */

public enum Season {
    WINTER,
    SPRING,
    SUMMER,
    FALL
}

public enum Status {
    DRAFT,
    PENDING,
    APPROVED,
    REJECTED
}

public class EnumExample {
    
    // Using enum as field type
    private Season currentSeason;
    private Status recordStatus;
    
    public EnumExample() {
        this.currentSeason = Season.WINTER;
        this.recordStatus = Status.DRAFT;
    }
    
    // Enum methods
    public void demonstrateEnumMethods() {
        // name() - returns the name as a string
        System.debug(Season.WINTER.name()); // 'WINTER'
        
        // ordinal() - returns the position (0-based)
        System.debug(Season.WINTER.ordinal()); // 0
        System.debug(Season.SUMMER.ordinal()); // 2
        
        // values() - returns all enum values
        List<Season> allSeasons = Season.values();
        for (Season s : allSeasons) {
            System.debug(s.name() + ' at position ' + s.ordinal());
        }
    }
    
    // Using enum in switch statement
    public String getSeasonDescription(Season season) {
        String description;
        switch on season {
            when WINTER {
                description = 'Cold and snowy';
            }
            when SPRING {
                description = 'Flowers blooming';
            }
            when SUMMER {
                description = 'Hot and sunny';
            }
            when FALL {
                description = 'Leaves falling';
            }
        }
        return description;
    }
    
    // Using enum for state management
    public Boolean canApprove() {
        return this.recordStatus == Status.PENDING;
    }
    
    public void approve() {
        if (canApprove()) {
            this.recordStatus = Status.APPROVED;
        }
    }
}

/* USAGE EXAMPLE:
EnumExample example = new EnumExample();
example.demonstrateEnumMethods();

System.debug(example.getSeasonDescription(Season.SUMMER)); // Hot and sunny

// Enum comparison
if (Season.WINTER == Season.WINTER) {
    System.debug('Seasons match');
}

// Convert string to enum
Season s = Season.valueOf('SPRING');
System.debug(s); // SPRING
*/
