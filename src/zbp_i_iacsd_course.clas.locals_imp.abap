CLASS lhc_Course DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Course RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Course RESULT result.

    METHODS SetDefaultValues FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Course~SetDefaultValues.
    METHODS validateCourse FOR VALIDATE ON SAVE
      IMPORTING keys FOR Course~validateCourse.

    METHODS validateDuration FOR VALIDATE ON SAVE
      IMPORTING keys FOR Course~validateDuration.

    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE Course.

    METHODS get_last_number
      RETURNING VALUE(rv_last_number) TYPE i.


ENDCLASS.

CLASS lhc_Course IMPLEMENTATION.

  METHOD get_instance_authorizations.
*    LOOP AT keys INTO DATA(ls_key).
*
*    APPEND VALUE #(
*
*      %tky = ls_key-%tky
*
*      %update = if_abap_behv=>auth-allowed
*
*      %delete = if_abap_behv=>auth-allowed
*
*    ) TO result.
*
*  ENDLOOP.

  ENDMETHOD.

  METHOD get_global_authorizations.
*  IF requested_authorizations-%create = if_abap_behv=>mk-on.
*    result-%create = if_abap_behv=>auth-allowed.
*    ENDIF.
  ENDMETHOD.

  METHOD SetDefaultValues.
    READ ENTITIES OF zi_iacsd_course IN LOCAL MODE
    ENTITY Course
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_course).

    DATA lt_update TYPE TABLE FOR UPDATE zi_iacsd_course.
    DATA ls_update LIKE LINE OF lt_update.

    LOOP AT lt_course INTO DATA(ls_course).

      CLEAR ls_update.

      ls_update-%tky = ls_course-%tky.
      "IF ls_course-Status IS INITIAL.
      ls_update-Status = 'A'.
      ls_update-%control-Status = if_abap_behv=>mk-on.
      "ENDIF.

      "IF ls_course-Duration IS INITIAL.
      ls_update-Duration = 24.
      ls_update-%control-Duration = if_abap_behv=>mk-on.
      "ENDIF.
      APPEND ls_update TO lt_update.

    ENDLOOP.

    MODIFY ENTITIES OF zi_iacsd_course IN LOCAL MODE
    ENTITY Course
    UPDATE FIELDS ( Status Duration )
    WITH lt_update.


  ENDMETHOD.

  METHOD earlynumbering_create.
    DATA lv_max TYPE i.
    lv_max = get_last_number( ).
    LOOP AT entities INTO DATA(ls_entity).
      APPEND INITIAL LINE TO mapped-course ASSIGNING FIELD-SYMBOL(<ls_map>).

      <ls_map>-%cid      = ls_entity-%cid.
      <ls_map>-%is_draft = ls_entity-%is_draft.
      "If CourseId already exists, keep it
      IF ls_entity-CourseId IS NOT INITIAL.
        <ls_map>-%key-CourseId = ls_entity-CourseId.
      ELSE.
        lv_max += 1.
        <ls_map>-%key-CourseId = |{ lv_max }|.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD get_last_number.
    SELECT MAX( course_id )
     FROM ziacsdcourse
     INTO @DATA(lv_active).

    SELECT MAX( courseid )
      FROM ziacsdcourse_d
      INTO @DATA(lv_draft).

    rv_last_number = COND i(
                        WHEN lv_active > lv_draft
                        THEN CONV i( lv_active )
                        ELSE CONV i( lv_draft ) ).

  ENDMETHOD.

  METHOD validateCourse.
    READ ENTITIES OF zi_iacsd_course IN LOCAL MODE
    ENTITY Course
    FIELDS ( CourseId CourseName )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_course).
    " validation for mandatory
    LOOP AT lt_course INTO DATA(ls_course).
      IF ls_course-CourseName IS INITIAL.

        APPEND VALUE #( %tky = ls_course-%tky ) TO failed-course.
        APPEND VALUE #( %tky = ls_course-%tky
         %msg = new_message(
                  id       = 'Z_INSTITUTE_MSG'
                  number   = '003'
                  severity = ms-error
                ) ) TO reported-course.
        CONTINUE.
      ENDIF.
      " validation for duplicate course
      DATA(lv_exists) = abap_false.

      SELECT SINGLE course_id
      FROM ziacsdcourse
      WHERE course_name = @ls_course-CourseName
        AND course_id <> @ls_course-CourseId
      INTO @DATA(lv_dummy).

      IF sy-subrc = 0.
        lv_exists = abap_true.
      ENDIF.
      "Draft Table
      IF lv_exists = abap_false.

        SELECT SINGLE courseid
          FROM ziacsdcourse_d
          WHERE courseid = @ls_course-CourseId
          INTO @DATA(lv_draft).

        IF sy-subrc = 0.
          lv_exists = abap_true.
        ENDIF.

      ENDIF.

      IF lv_exists = abap_true.
        APPEND VALUE #(
               %tky = ls_course-%tky
             ) TO failed-course.

        APPEND VALUE #(
          %tky = ls_course-%tky
          %msg = new_message(
                   id       = 'Z_INSTITUTE_MSG'
                   number   = '004'
                   severity = ms-error )
        ) TO reported-course.

      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validateDuration.
    READ ENTITIES OF zi_iacsd_course IN LOCAL MODE
    ENTITY Course
    FIELDS ( Duration )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_course).

    LOOP AT lt_course INTO DATA(ls_course).
      IF ls_course-Duration <= 0.
        APPEND VALUE #( %tky = ls_course-%tky ) TO failed-course.
        APPEND VALUE #( %tky = ls_course-%tky
        %msg = new_message(
                 id       = 'Z_INSTITUTE_MSG'
                 number   = '005'
                 severity = ms-error
               ) ) TO reported-course.

      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
