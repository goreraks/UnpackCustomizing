FUNCTION ZBCSETS_UNPACK.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IT_BCSETS) TYPE  ZBCSETS_TT
*"----------------------------------------------------------------------
  DATA: lo_container TYPE REF TO if_bcfg_config_container,
        lo_result    TYPE REF TO if_bcfg_result_apply,
        lo_error     TYPE REF TO cx_root.

  DATA: lv_id TYPE string.

  FIELD-SYMBOLS: <lv_bcset> TYPE scpr_id.


  LOOP AT it_bcsets[] ASSIGNING <lv_bcset>.

    TRY.

        lv_id = <lv_bcset>.

*       Create container
        lo_container = cl_bcfg_config_manager=>find_container( io_container_type = cl_bcfg_enum_container_type=>classic
                                                               iv_id             = lv_id
                       ).

*       Apply customizing
        lo_result = lo_container->apply( ).

      CATCH cx_root INTO lo_error. " raised if the requested TX mode is not suitable

    ENDTRY.

  ENDLOOP.


ENDFUNCTION.
