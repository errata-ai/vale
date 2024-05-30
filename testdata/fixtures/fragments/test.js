var mdTable = require('markdown-table')

/**
 * Get all boolean input values for n variables.
 *
 * @example
 * // [ [ true, true ], [ true, false ], [ false, true ], [ false, false ] ]
 * getValues(2, [])
 *
 * @param   {Number} n - The number of variables.
 * @param   {Array} t - The array to be recursively filled.
 *
 * @returns {Array} All possible input values.
 */
function getValues(n, t) {
  if (t.length === n) {
    return [t]
  } else {
    return getValues(n, t.concat(true)).concat(getValues(n, t.concat(false)))
  }
}

/**
 * Get all boolean values for each variable.
 *
 * @example
 * // [ { P: true }, { P: false } ]
 * getCases (['P'])
 *
 * @param   {Array} variables - All variables in a given statement.
 *
 * @returns {Array} - An array of objects mapping variables to their possible
 *  values.
 */
function getCases(variables) {
  var numVars = variables.length
  var values = getValues(numVars, [])
  var numRows = values.length
  var rows = [] var row = {}

  for (var i = 0; i < numRows; ++i) {
    row = {} for (var j = 0; j < numVars; ++j) {
      row[variables[j]] = values[i][j]
    }
    rows.push(row)
  }

  return rows
}

/**
 * Convert a statement into an object representing the structure of a table.
 *
 * @param   {Object} s - The statement to be converted.
 *
 * @returns {Object} - The table representation.
 */
function statementToTable(s) {
  var table = {}

  table['statement'] = s.statement
  table['variables'] = s.variables
  table['rows'] = getCases(table['variables'])
  for (var i = 0; i < table['rows'].length; ++i) {
    table['rows'][i]['eval'] = s.evaluate(table['rows'][i])
  }

  return table
}

/**
 * Create a Markdown-formatted truth table.
 *
 * @param   {Object} table - The table to be converted to Markdown.
 *
 * @returns {String} The Markdown-formatted table.
 */
function tableToMarkdown(table) {
  var rows = [] var row = [] var header = table['variables'].slice()

  header.push(table['statement'].replace(/\|/g, '&#124;'))
  rows.push(header)
  for (var i = 0; i < table['rows'].length; ++i) {
    row = [] for (var j = 0; j < table['variables'].length; ++j) {
      row.push(table['rows'][i][table['variables'][j]])
    }
    row.push(table['rows'][i]['eval'])
    rows.push(row)
  }

  return mdTable(rows, {align: 'c'})
}

/**
 * Create a truth table from a given statement.
 *
 * @param   {String} s - The statement.
 * @param   {String} type - The table format.
 *
 * @returns {String} - The formatted table.
 */
function makeTruthTable(s, type) {
  var table = statementToTable(s)
  var format = type.toLowerCase()

  // TODO: Add support for other formats
  switch (format) {
    case 'markdown':
      return tableToMarkdown(table)
  }
}

// module.exports.truthTable = makeTruthTable
export default makeTruthTable