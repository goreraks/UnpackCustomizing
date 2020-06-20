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

    DATA: lt_bcsets TYPE zbcsets_tt.

    FIELD-SYMBOLS: <ls_object> TYPE zif_abapgit_definitions=>ty_deserialization.

    CHECK is_step-is_ddic = abap_false.

    LOOP AT is_step-objects[] ASSIGNING <ls_object>.

      CHECK <ls_object>-item-obj_type = 'SCP1'.

      APPEND <ls_object>-item-obj_name TO lt_bcsets[].

    ENDLOOP.

*   Unpack BC Sets
    CALL FUNCTION 'ZBCSETS_UNPACK' STARTING NEW TASK 'ACTIVATE'
      DESTINATION 'NONE'
      EXPORTING
        it_bcsets             = lt_bcsets[]
      EXCEPTIONS
        system_failure        = 1
        communication_failure = 2
        resource_failure      = 3
        OTHERS                = 4.

  ENDMETHOD.

ENDCLASS.
