`timescale 1ns/100ps
module tb_top ();
    // VARIABLES
    localparam time CLK_PERIOD = 100;
    integer TESTS_FAILED = 0;
    integer TESTS_PASSED = 0;
    integer TEST_NUMBER = 0;
    string TEST_NAME = "No Test Name Given";

    // SIGNALS
    logic tb_clk, tb_nrst, tb_cs;
    logic [33:0] tb_gpio;

    // TASKS
    task RESET ();
        @(negedge tb_clk);
        tb_nrst = 0;

        @(negedge tb_clk);
        tb_nrst = 1;
    endtask

    task SET_CS ();
        tb_cs = 0;
    endtask
    
    task RESET_CS ();
        tb_cs = 1;
    endtask

    task WAIT (
        input integer cycles
    );
        for (integer i = 0; i < cycles; i = i + 1)
            @(posedge tb_clk);
    endtask

    task FEED_INPUTS (
        input [33:0] gpio
    );

        @(negedge tb_clk);
        tb_gpio = gpio;

    endtask

    task ASSERT_OUTPUTS (
        input [33:0] gpio,
        input string test_name
    );

        TEST_NUMBER = TEST_NUMBER + 1;
        TEST_NAME = test_name
        @(negedge tb_clk);
        if (tb_gpio != gpio) begin
            $error("Test %d: %s Failed", TEST_NUMBER, TEST_NAME);
            $error("Expected: %b", gpio);
            #error("Actual: %b", tb_gpio);
            TESTS_FAILED = TESTS_FAILED + 1;
        end else begin
            $info("Test %d: %s Passed", TEST_NUMBER, TEST_NAME);
            TESTS_PASSED = TESTS_PASSED + 1;
        end

    endtask

    // DUTs
    silly_synthesizer dut_top (tb_clk, tb_nrst, tb_cs, tb_gpio);

    // CLOCKING
    always @(*) begin
        tb_clk = 1;
        #(CLK_PERIOD/2);
        tb_clk = 0;
        #(CLK_PERIOD/2);
    end

    // TESTS
    initial begin

        // SETUP
        tb_nrst = 1;
        tb_cs = 1;
        tb_gpio = 34'bz;
        #1;

        // TEST 1: Power-On Reset
        tb_nrst = 0;
        tb_cs = 0;
        #10;
        
        tb_nrst = 1;

        ASSERT_OUTPUTS({33'bx, 1'b0}, "Power-On Reset");
        // END TEST 1


        // TEST 2-4: First Pulse
        WAIT(2500000-1);

        ASSERT_OUTPUTS({33'bx, 1'b0}, "Before First Pulse");
        ASSERT_OUTPUTS({33'bx, 1'b1}, "During First Pulse");
        ASSERT_OUTPUTS({33'bx, 1'b0}, "After First Pulse");
        // END TEST 2-4


        // TEST 5-7: Reset
        WAIT(134554);
        RESET();
        WAIT(2500000-1);

        ASSERT_OUTPUTS({33'bx, 1'b0}, "Before Reset Pulse");
        ASSERT_OUTPUTS({33'bx, 1'b1}, "During Reset Pulse");
        ASSERT_OUTPUTS({33'bx, 1'b0}, "After Reset Pulse");
        // END TEST 5-7
    
    end

endmodule