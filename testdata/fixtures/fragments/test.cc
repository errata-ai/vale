
/*!
    \class QObject
    \brief The QObject class is the base class of all Qt objects.

    \ingroup objectmodel

    \reentrant

    QObject is the heart of the Qt \l{Object Model}. The
    central feature in this model is a very powerful mechanism
    for seamless object communication called \l{signals and
    slots}. You can connect a signal to a slot with connect()
    and destroy the the connection with disconnect(). To avoid
    never ending notification loops you can temporarily block
    signals with blockSignals(). The protected functions
    connectNotify() and disconnectNotify() make it possible to
    track connections.

    QObjects organize themselves in \l {Object Trees &
    Ownership} {object trees}. When you create a QObject with
    another object as parent, the object will automatically
    add itself to the parent's \c children() list. The parent
    takes ownership of the object. It will automatically
    delete its children in its destructor. You can look for an
    object by name and optionally type using findChild() or
    findChildren().

    Every object has an objectName() and its class name can be
    found via the corresponding metaObject() (see
    QMetaObject::className()). You can determine whether the
    object's class inherits another class in the QObject
    inheritance hierarchy by using the \c inherits() function.
*/

#include <fstream>
#include <iostream>
using namespace std;

int main() {
  // Create and open a text file
  ofstream MyFile("filename.txt");

  // Write to the file
  MyFile << "Files can be tricky, but it is fun enough!";

  // Close the the file
  MyFile.close();

  // Call \c func to start the process.
}
