#[allow(non_camel_case_types)]
struct cout;

impl<T> std::ops::Shl<T> for cout {
    type Output = cout; // TODO: we need to fix this.

    fn shl(self, x: T) -> cout {
        print!("{}", x);
        cout // This is a comment (i.e., it should be linted.)
    }
}

// There are more than 5 comments.
fn main() {
    cout << "1 + 1 = " << 1 + 1 << '\n';
}
