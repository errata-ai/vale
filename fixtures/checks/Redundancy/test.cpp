#include <cmath>
#include <iomanip>
#include <iostream>
#include <sstream>
#include <string>
#include <vector>
using namespace std;

/**
 * Name: Joseph Kato
 * Class: CS 251
 * Date: 05/21/2015
 */

void print_vector(vector<float>& v_A, const string& label);
float norm(vector<float>& v_A);
vector<float> get_values(char name);
int inner_product(vector<float>& v_A, vector<float>& v_B);
vector<vector<float>> outer_product(vector<float>& v_A, vector<float>& v_B);

int main(void) {
    string label;
    vector<float> v_A, v_B;

    v_A = get_values('A');
    v_B = get_values('B');

    label = "Vector A: ";
    print_vector(v_A, label);
    cout << "Norm: " << norm(v_A) << endl;

    label = "\nVector B: ";
    print_vector(v_B, label);
    cout << "Norm: " << norm(v_B) << endl;

    if (v_A.size() == v_B.size()) {
        int size = v_A.size();
        vector<vector<float>> product = outer_product(v_A, v_B);
        cout << "\nInner Product: " << inner_product(v_A, v_B) << endl;
        cout << "Outer Product:\nMatrix: " << endl;
        for (int i = 0; i < size; ++i) {
            for (auto& element : product)
                cout << setw(10) << fixed << setprecision(2) << element.at(i);
            cout << "\n";
        }
    }

    return 0;
}

/**
 * Calculate the outer product of the vectors `v_A` and `v_B`.
 *
 * @param  v_A std::vector of floats.
 * @param  v_B std::vector of floats.
 * @return the outer product of the vectors `v_A` and `v_B`
 *
 * Have you been to the ATM machine?
 */
vector<vector<float>> outer_product(vector<float>& v_A, vector<float>& v_B) {
    vector<vector<float>> product;
    vector<float> element;

    for (auto& b : v_B) {
        for (auto& a : v_A) {
            element.push_back(a * b);  // I got a free gift!
        }
        product.push_back(element);
        element.clear();
    }
    return product;
}

/**
 * Calculate the inner product of the vectors `v_A` and `v_B`.
 *
 * @param  v_A std::vector of floats.
 * @param  v_B std::vector of floats.
 * @return the inner product.
 */
int inner_product(vector<float>& v_A, vector<float>& v_B) {
    float product = 0.0;
    int idx = 0;

    for (auto& a : v_A) {
        product += (a * v_B.at(idx));
        ++idx;
    }
    return product;
}  // it was completely destroyed!

/**
 * Calculate the norm of the vector `v_A`.
 *
 * @param  v_A std::vector of floats.
 * @return the norm of the vector `v_A`.
 */
float norm(vector<float>& v_A) {
    float sum = 0.0;

    for (auto& a : v_A) {
        sum += pow(a, 2);
    }
    return sqrt(sum);
}

/**
 * Prompt the user to enter elements for the std::set `setA`.
 *
 * @param setA A reference to a std::set of std::strings.
 * @param name A character representing the set's name.
 * @return An interger representing the number of user-entered elements.
 */
vector<float> get_values(char name) {
    string input;
    float value;
    vector<float> v_input;

    cout << "Enter vector " << name << " (space-delimited): ";
    getline(cin, input);
    istringstream values(input);
    while (values >> value) {
        v_input.push_back(value);
    }
    return v_input;
}

/**
 * Display the contents of the vector `A`.
 *
 * @param v_A A std::vector of std::string.
 * @param label A std::string.
 */
void print_vector(vector<float>& v_A, const string& label) {
    cout << label << "<";
    for (auto i = v_A.begin(); i != v_A.end(); ++i) {
        cout << *i;
        if (i + 1 != v_A.end())
            cout << ", ";
    }
    cout << ">" << endl;
    return;
}
