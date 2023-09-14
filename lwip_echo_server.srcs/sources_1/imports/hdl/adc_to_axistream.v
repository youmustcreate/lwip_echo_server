`timescale 1ns / 1ps

module adc_to_axistream(
	input 			        clk_i               ,
	input 				     reset_n             ,
	input       		     adc_capture_en_i    ,
	input       [127:0]	  adc_data_i          ,
	input       	        s_axis_adc_tready   ,
	output reg	           s_axis_adc_tvalid   ,
	output reg  [127:0]    s_axis_adc_tdata    ,
	output wire [15:0]     s_axis_adc_tkeep    ,
	output reg             s_axis_adc_tlast   
);


reg [1:0]    state;
reg [15:0]   data_cnt;

assign s_axis_adc_tkeep = 16'hffff;

always@(posedge clk_i)begin
     if(!reset_n) begin
         s_axis_adc_tvalid <= 1'b0;
		   s_axis_adc_tdata  <= 128'd0;
         data_cnt          <= 16'd0;
         s_axis_adc_tlast  <= 1'b0;
         state             <=0;
     end
     else begin
        case(state)
          0: begin
              if(adc_capture_en_i && s_axis_adc_tready) begin
                 s_axis_adc_tvalid <= 1'b1;
				     s_axis_adc_tdata  <= adc_data_i;
                 state <= 1;
              end
              else begin
                 s_axis_adc_tvalid <= 1'b0;
				     s_axis_adc_tdata  <= 128'd0;
                 state <= 0;
              end
            end


          1:begin
               if(s_axis_adc_tready) begin
				       s_axis_adc_tdata     <= adc_data_i;
				       s_axis_adc_tvalid    <= 1'b1;   
                   data_cnt             <= data_cnt + 1'b1;
                   
                   if(data_cnt == 16'd1021) begin
                      s_axis_adc_tlast <= 1'b1;
                      state <= 2;
                   end

                   else begin
                      s_axis_adc_tlast <= 1'b0;
                      state <= 1;
                   end
               end

               else begin
			         s_axis_adc_tdata   <= s_axis_adc_tdata;
				      s_axis_adc_tlast   <= 1'b0;
				      s_axis_adc_tvalid  <= 1'b0;
                  data_cnt           <= data_cnt;
                  state              <= 1;
               end
            end

          2:begin
               if(!s_axis_adc_tready) begin
                  s_axis_adc_tvalid  <= 1'b1;
				      s_axis_adc_tdata   <= s_axis_adc_tdata;
                  s_axis_adc_tlast   <= 1'b1;
                  data_cnt           <= data_cnt;
                  state              <= 2;
               end

               else begin
                  s_axis_adc_tvalid  <= 1'b0;
				      s_axis_adc_tdata   <= 128'd0;
                  s_axis_adc_tlast   <= 1'b0;
                  data_cnt           <= 16'd0;
                  state              <= 0;
               end
            end

         default: state <=0;
         endcase
     end              
 end




ila_0 u_ila_0(
.clk     (clk_i             ),
.probe0  (s_axis_adc_tready ),
.probe1  (s_axis_adc_tvalid ),
.probe2  (s_axis_adc_tlast  ),
.probe3  (state             ),
.probe4  (adc_capture_en_i  ),
.probe5  (reset_n           ),
.probe6  (data_cnt          ),
.probe7  (s_axis_adc_tdata  )
// .probe6  (       ),
// .probe7  (       ),
// .probe8  (       ),
// .probe9  (       )
);


endmodule






// always@(posedge clk_i)begin
//      if(!reset_n) begin
//          s_axis_adc_tvalid <= 1'b0     ;
// 		   s_axis_adc_tdata  <= 128'd0   ;
//          s_axis_adc_tlast  <= 1'b0     ;
//          state <=0                     ;
//      end
//      else begin
//         case(state)
//           0: begin
//               if(adc_capture_en_i && s_axis_adc_tready) begin
//                  s_axis_adc_tvalid  <= 1'b1        ;
// 				     s_axis_adc_tdata   <= adc_data_i  ;
//                  state <= 1                        ;
//               end
//             end

//           1:begin
//                if(s_axis_adc_tready) begin
// 				      s_axis_adc_tdata   <= adc_data_i  ;
// 				      s_axis_adc_tvalid  <= 1'b1        ;
//                   s_axis_adc_tlast   <= 1'b1        ;
//                   state              <= 2           ;
//                end

//                else begin
// 			         s_axis_adc_tdata  <= s_axis_adc_tdata  ;
// 				      s_axis_adc_tlast  <= 1'b0              ;
// 				      s_axis_adc_tvalid <= 1'b0              ;
//                   state             <= 1                 ;
//                end
//             end

//           2:begin
//                if(!s_axis_adc_tready) begin   // s_axis_adc_tready 0
//                   s_axis_adc_tvalid <= 1'b1;
//                   s_axis_adc_tlast  <= 1'b1;
// 				      s_axis_adc_tdata  <= s_axis_adc_tdata;
//                   state             <= 2;
//                end

//                else begin   // s_axis_adc_tready 变为1
//                   s_axis_adc_tvalid <= 1'b0;
// 				      s_axis_adc_tdata  <= 128'd0;
//                   s_axis_adc_tlast  <= 1'b0;      //  此时的tlast�??1 写入
//                   state             <= 0;
//                end
//             end
//          default: state <=0;
//          endcase
//      end
//  end