// XXX: This is an annotation
// And this uses too many weasel words like obviously and very.
function formatName(user) {
  // NOTE: this is a comment.
  return user.firstName + ' ' + user.lastName;
}

const user = {
  firstName: 'Harper',
  lastName: 'Perez'
};

/*
  XXX: Block comment
*/
const element = (
  <h1>
    Hello, {formatName(user)}! { /* TODO: JSX comment */ }
  </h1>
);
