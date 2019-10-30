module testAnythingProtocol
    #(  parameter TAP_FOLDER = "",
        parameter TAP_FILE = "",
        parameter MAX_STRING_LENGTH = 80);

    integer hTap; //File handle for tap file
    integer hTemp; //File handle for temporary file
    integer testCaseIdx = 0; //Current testcase index
    integer totalCharacters = 0;
    reg[7:0] character;

    initial begin
        if(TAP_FILE == 0 || TAP_FOLDER == 0)
            $display("No TAP_FOLDER or TAP_FILE specified");
        else begin
            hTemp = $fopen({TAP_FOLDER, "/tap.tmp"},"w");
        end
    end

    task assert (
        input sucess,
        input [MAX_STRING_LENGTH*8-1:0] message
    );
        begin
            // add test case to temp file
            testCaseIdx = testCaseIdx + 1;
            if (sucess) begin
                $fwrite(hTemp, "ok %0d - %0s\n", testCaseIdx, message);
            end else begin
                $fwrite(hTemp, "not ok %0d - %0s\n", testCaseIdx, message);
            end
        end
    endtask

    task finish;
        begin
            $fclose(hTemp);
            hTemp = $fopen({TAP_FOLDER, "/tap.tmp"},"r");
            hTap = $fopen({TAP_FOLDER, "/", TAP_FILE},"w");

            // Copy content to tap file including header
            $fwrite(hTap, "1..%0d\n", testCaseIdx);

            character = $fgetc(hTemp);
            while (character <= 126) begin
                $fwrite(hTap, "%c", character);
                character = $fgetc(hTemp);
            end

            $fclose(hTap);
            $fclose(hTemp);
            $finish;
        end
    endtask
endmodule