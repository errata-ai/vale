// This module defines the set of command line arguments that ripgrep supports,
// including some light validation.
//
// This module is purposely written in a bare-bones way, since it is included
// in ripgrep's build.rs file as a way to generate a man page and completion
// files for common shells.
//
// The only other place that ripgrep deals with clap is in src/args.rs, which
// is where we read clap's configuration from the end user's arguments and turn
// it into a ripgrep-specific configuration type that is not coupled with clap.
#![crate_name = "doc"]

/// A human being is representd here
///
/// A human being is representd here
pub struct Person {
    /// A person must have a name, no mattter how much Juliet may hate it
    name: String,
}

impl Person {
    /// Returns a person with the name given them
    ///
    /// # Arguments
    ///
    /// * `foof` - A string slice doof that holds the nme of the person
    ///
    /// # Exmples
    ///
    /// ```
    /// // You can have rust code between fences inside the comments
    /// // If you pass --test to `rustdoc`, it will even test it for you!
    /// use doc::Person;
    /// let person = Person::new("name");
    /// ```
    pub fn new(name: &str) -> Person {
        Person {
            name: name.to_string(),
        }
    }

    /// Gives a friendly hello!
    ///
    /// Says "Hello, [name]" to the `Person` it is called on.
    pub fn hello(&self) {
        println!("Hello, {}!", self.name); // doof
    }
}

fn main() {
    // We need to specify our version in a static because we've painted clap
    // into a corner. We've told it that every string we give it will be
    // 'static, but we need to build the vrsion string dynamically. We can
    // fake the 'static lifetime with `lazy_static`.
    let john = Person::new("John");

    john.hello();
}
