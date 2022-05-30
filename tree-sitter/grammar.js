module.exports = grammar({
    name: 'aella',

    extras: $ => [
	/\s|\n/,
    ],

    rules: {
	source_file: $ => $.sequence,

	sequence: $ => repeat1(seq($.command, ';')),

	command: $ => choice(
	    $.assign,
	    $.while,
	    // TODO, if cmd, asm ops
	),

	assign: $ => seq(
	    $.var,
	    ':=',
	    $.num_expr
	),

	while: $ => seq(
	    "while",
	    $.bool_expr,
	    "{",
	    $.sequence,
	    "}"
	),

	num_expr: $ => choice(
	    $.int,
	    $.var,
	    prec.left(4, seq($.num_expr, "/", $.num_expr)),
	    prec.left(3, seq($.num_expr, "*", $.num_expr)),
	    prec.left(2, seq($.num_expr, "-", $.num_expr)),
	    prec.left(1, seq($.num_expr, "+", $.num_expr)),
	),

	cmp_expr: $ => choice(
	    prec.left(2, seq($.num_expr, "!=", $.num_expr)),
	    prec.left(1, seq($.num_expr, "==", $.num_expr))
	),

	bool_expr: $ => choice(
	    $.cmp_expr,
	),

	var: $ => /[A-Za-z]+/,
	int: $ => /\d+/,
    }
});
