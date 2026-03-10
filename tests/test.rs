// Test file for GynColors theme - Rust syntax.
// Comment: should be bright green (#00ff00)

use std::collections::HashMap;
use std::fmt;
use std::io::{self, Read, Write};

/// Doc comment: should also be green
/// With `code spans` inside

const MAX_ITEMS: usize = 100;
static GLOBAL_NAME: &str = "GynColors";

// Enum with variants
#[derive(Debug, Clone, PartialEq)]
enum Shape {
    Circle(f64),
    Rectangle { width: f64, height: f64 },
    Triangle(f64, f64, f64),
    Point,
}

// Struct with lifetime
#[derive(Debug)]
struct Container<'a, T: fmt::Display> {
    name: &'a str,
    items: Vec<T>,
    metadata: HashMap<String, String>,
}

// Trait definition
trait Area {
    fn area(&self) -> f64;
    fn perimeter(&self) -> f64;
    fn describe(&self) -> String {
        format!("Shape with area {:.2}", self.area())
    }
}

// Trait implementation
impl Area for Shape {
    fn area(&self) -> f64 {
        match self {
            Shape::Circle(r) => std::f64::consts::PI * r * r,
            Shape::Rectangle { width, height } => width * height,
            Shape::Triangle(a, b, c) => {
                let s = (a + b + c) / 2.0;
                (s * (s - a) * (s - b) * (s - c)).sqrt()
            }
            Shape::Point => 0.0,
        }
    }

    fn perimeter(&self) -> f64 {
        match self {
            Shape::Circle(r) => 2.0 * std::f64::consts::PI * r,
            Shape::Rectangle { width, height } => 2.0 * (width + height),
            Shape::Triangle(a, b, c) => a + b + c,
            Shape::Point => 0.0,
        }
    }
}

// Display trait for Shape
impl fmt::Display for Shape {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Shape::Circle(r) => write!(f, "Circle(r={})", r),
            Shape::Rectangle { width, height } => {
                write!(f, "Rect({}x{})", width, height)
            }
            Shape::Triangle(a, b, c) => write!(f, "Tri({},{},{})", a, b, c),
            Shape::Point => write!(f, "Point"),
        }
    }
}

// Generic function with trait bounds
fn largest<T: PartialOrd + fmt::Display>(list: &[T]) -> &T {
    let mut largest = &list[0];
    for item in &list[1..] {
        if item > largest {
            largest = item;
        }
    }
    largest
}

// Impl block with methods
impl<'a, T: fmt::Display> Container<'a, T> {
    fn new(name: &'a str) -> Self {
        Container {
            name,
            items: Vec::new(),
            metadata: HashMap::new(),
        }
    }

    fn add(&mut self, item: T) {
        self.items.push(item);
    }

    fn len(&self) -> usize {
        self.items.len()
    }

    fn is_empty(&self) -> bool {
        self.items.is_empty()
    }
}

// Error handling
#[derive(Debug)]
enum AppError {
    Io(io::Error),
    Parse(std::num::ParseIntError),
    Custom(String),
}

impl fmt::Display for AppError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            AppError::Io(e) => write!(f, "IO error: {}", e),
            AppError::Parse(e) => write!(f, "Parse error: {}", e),
            AppError::Custom(msg) => write!(f, "Error: {}", msg),
        }
    }
}

impl From<io::Error> for AppError {
    fn from(e: io::Error) -> Self {
        AppError::Io(e)
    }
}

// Closures and iterators
fn functional_examples() {
    let numbers = vec![1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

    let sum: i32 = numbers.iter().sum();
    let evens: Vec<&i32> = numbers.iter().filter(|&&x| x % 2 == 0).collect();
    let doubled: Vec<i32> = numbers.iter().map(|&x| x * 2).collect();

    let mut accumulator = 0;
    let running_sum: Vec<i32> = numbers
        .iter()
        .map(|&x| {
            accumulator += x;
            accumulator
        })
        .collect();

    // Closure with move
    let name = String::from("test");
    let greeting = move || println!("Hello, {}", name);
    greeting();
}

// Numeric literals
fn numeric_types() {
    let decimal: i32 = 42;
    let hex: u32 = 0xFF;
    let octal: u32 = 0o77;
    let binary: u32 = 0b1111_0000;
    let byte: u8 = b'A';
    let float: f64 = 3.14_159;
    let scientific: f64 = 1.0e-7;
    let large: u64 = 1_000_000;
    let negative: i64 = -42;
}

// Pattern matching
fn process_option(opt: Option<i32>) -> String {
    match opt {
        Some(n) if n > 0 => format!("positive: {}", n),
        Some(0) => String::from("zero"),
        Some(n) => format!("negative: {}", n),
        None => String::from("nothing"),
    }
}

// Async (syntax)
async fn fetch_url(url: &str) -> Result<String, AppError> {
    let mut buffer = String::new();
    io::stdin().read_to_string(&mut buffer)?;
    Ok(buffer)
}

// Macro usage
macro_rules! create_map {
    ($($key:expr => $value:expr),* $(,)?) => {
        {
            let mut map = HashMap::new();
            $(map.insert($key, $value);)*
            map
        }
    };
}

fn main() {
    // Shapes
    let shapes: Vec<Shape> = vec![
        Shape::Circle(5.0),
        Shape::Rectangle { width: 10.0, height: 20.0 },
        Shape::Triangle(3.0, 4.0, 5.0),
        Shape::Point,
    ];

    for shape in &shapes {
        println!("{}: area = {:.2}, perimeter = {:.2}",
            shape, shape.area(), shape.perimeter());
    }

    // Container
    let mut container = Container::new("test");
    container.add(42);
    container.add(17);
    println!("Container '{}' has {} items", container.name, container.len());

    // Macro
    let config = create_map! {
        "name" => "GynColors",
        "version" => "2.0",
        "author" => "pawlos",
    };

    // If let / let else
    if let Some(name) = config.get("name") {
        println!("Config name: {}", name);
    }

    let Some(version) = config.get("version") else {
        eprintln!("No version found");
        return;
    };
    println!("Version: {}", version);

    // Boolean and comparison operators
    let a = true;
    let b = false;
    let result = a && !b || (42 > 17) && (3.14 <= 4.0);
    assert!(result);
}
