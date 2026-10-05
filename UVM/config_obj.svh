//------------------------------------------------------------------------------
// Author      : Yousef Gamal
// class Name  : MEM_cfg
//------------------------------------------------------------------------------

`ifndef CONFIG_OBJ_SVH
`define CONFIG_OBJ_SVH

class MEM_cfg extends uvm_object ;

    `uvm_object_utils(MEM_cfg)

    MEM_vif_t vif ; // Virtual interface handle

    //------------------------------------------------------------------------------
    // Constructor
    //------------------------------------------------------------------------------
    function new(string name = "MEM_cfg");
    
        super.new(name);
    
    endfunction

endclass

`endif // CONFIG_OBJ_SVH