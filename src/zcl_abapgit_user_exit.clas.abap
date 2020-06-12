CLASS zcl_abapgit_user_exit DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES zif_abapgit_exit.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_abapgit_user_exit IMPLEMENTATION.

  METHOD zif_abapgit_exit~deserialize_postprocess.

    DATA: lo_container TYPE REF TO if_bcfg_config_container,
          lo_result    TYPE REF TO if_bcfg_result_apply,
          lo_error     TYPE REF TO cx_root.

    DATA: lt_logs TYPE bapiret2_t.

    DATA: lv_id TYPE string.

    FIELD-SYMBOLS: <ls_object> TYPE zif_abapgit_definitions=>ty_deserialization,
                   <ls_log>    TYPE bapiret2.

    CHECK is_step-is_ddic = abap_false.

    LOOP AT is_step-objects[] ASSIGNING <ls_object>.

      CHECK <ls_object>-item-obj_type = 'SCP1'.

      lv_id = <ls_object>-item-obj_name.

      TRY.

*         Create container
          lo_container = cl_bcfg_config_manager=>find_container( io_container_type = cl_bcfg_enum_container_type=>classic
                                                                 iv_id             = lv_id
                         ).

*         Apply customizing
          lo_result = lo_container->apply( ).

*         Get logs
          lt_logs = lo_result->get_log_messages( ).

          LOOP AT lt_logs ASSIGNING <ls_log>.

            ii_log->add(
              EXPORTING
                iv_msg  = <ls_log>-message
                iv_type = <ls_log>-type
            ).

          ENDLOOP.

        CATCH cx_root INTO lo_error. " raised if the requested TX mode is not suitable
          ii_log->add_exception(
            EXPORTING
              ix_exc  = lo_error
              is_item = <ls_object>-item
          ).

      ENDTRY.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
