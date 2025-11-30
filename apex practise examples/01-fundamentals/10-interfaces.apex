/**
 * 10 - Interfaces
 * Demonstrates: Interface declaration, implementation, polymorphism
 */

// Define an interface
public interface Drawable {
    void draw();
    String getDescription();
}

// Another interface
public interface Colorable {
    void setColor(String color);
    String getColor();
}

// Class implementing one interface
public class Circle implements Drawable {
    private Decimal radius;
    
    public Circle(Decimal radius) {
        this.radius = radius;
    }
    
    public void draw() {
        System.debug('Drawing circle with radius: ' + radius);
    }
    
    public String getDescription() {
        return 'Circle (r=' + radius + ')';
    }
}

// Class implementing multiple interfaces
public class Rectangle implements Drawable, Colorable {
    private Decimal width;
    private Decimal height;
    private String color;
    
    public Rectangle(Decimal width, Decimal height) {
        this.width = width;
        this.height = height;
        this.color = 'Black';
    }
    
    public void draw() {
        System.debug('Drawing ' + color + ' rectangle: ' + width + 'x' + height);
    }
    
    public String getDescription() {
        return color + ' Rectangle (' + width + 'x' + height + ')';
    }
    
    public void setColor(String color) {
        this.color = color;
    }
    
    public String getColor() {
        return this.color;
    }
}

public class InterfaceExample {
    // Polymorphism with interfaces
    public static void drawShape(Drawable shape) {
        System.debug(shape.getDescription());
        shape.draw();
    }
    
    public static void demonstrateInterfaces() {
        Circle circle = new Circle(5.0);
        Rectangle rect = new Rectangle(10.0, 20.0);
        
        // Polymorphism
        drawShape(circle);
        drawShape(rect);
        
        // Multiple interfaces
        if (rect instanceof Colorable) {
            Colorable colorable = (Colorable) rect;
            colorable.setColor('Red');
            System.debug('Color: ' + colorable.getColor());
        }
    }
}

/* USAGE EXAMPLE:
InterfaceExample.demonstrateInterfaces();

// List of interface type (polymorphism)
List<Drawable> shapes = new List<Drawable>{
    new Circle(3.0),
    new Rectangle(5.0, 10.0)
};

for (Drawable shape : shapes) {
    shape.draw();
}
*/
