module tb;

  reg  [3:0] t_a;
  reg  [3:0] t_b;
  reg        t_op;

  wire [3:0] t_result;

  integer a, b;
  integer errors;
  integer total;

  reg [3:0] expected;

  alu DUT (
    .a      (t_a),
    .b      (t_b),
    .op     (t_op),
    .result (t_result)
  );

  string vcd_file;

  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  initial begin

    errors = 0;
    total  = 0;

    for (a = 0; a < 16; a = a + 1) begin
      for (b = 0; b < 16; b = b + 1) begin

        // ADD test
        t_a  = a;
        t_b  = b;
        t_op = 0;

        #1;

        expected = a + b;

        if (t_result !== expected) begin
          $display("FAIL ADD: a=%0d b=%0d got=%0d expected=%0d",
                   a, b, t_result, expected);
          errors = errors + 1;
        end

        total = total + 1;

        // SUB test
        t_op = 1;

        #1;

        expected = a - b;

        if (t_result !== expected) begin
          $display("FAIL SUB: a=%0d b=%0d got=%0d expected=%0d",
                   a, b, t_result, expected);
          errors = errors + 1;
        end

        total = total + 1;

      end
    end

    $display("--------------------------------");
    $display("Passed = %0d", total-errors);
    $display("Failed = %0d", errors);
    $display("Total  = %0d", total);
    $display("--------------------------------");

    $finish;

  end

  initial
    $monitor($time,
             " a=%0d b=%0d op=%b result=%0d",
             t_a, t_b, t_op, t_result);

endmodule