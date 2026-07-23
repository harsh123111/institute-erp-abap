CLASS lhc_subject DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS validateSubject FOR VALIDATE ON SAVE
      IMPORTING keys FOR Subject~validateSubject.

    METHODS validateSubjectDuration FOR VALIDATE ON SAVE
      IMPORTING keys FOR Subject~validateSubjectDuration.


ENDCLASS.

CLASS lhc_subject IMPLEMENTATION.

  METHOD validateSubject.
    " validation for subject mandatory
    READ ENTITIES OF zi_iacsd_course IN LOCAL MODE
    ENTITY Subject
    FIELDS ( SubjectId SubjectName CourseId )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_subject).

    LOOP AT lt_subject INTO DATA(ls_subject).
      IF ls_subject-SubjectName IS INITIAL.
        APPEND VALUE #( %tky = ls_subject-%tky ) TO failed-subject.
        APPEND VALUE #( %tky = ls_subject-%tky
        %msg = new_message(
                 id       = 'Z_INSTITUTE_MSG'
                 number   = '006'
                 severity = ms-error
               ) ) TO reported-subject.
        CONTINUE.
      ENDIF.
      "validation for duplicate subject name
      LOOP AT lt_subject INTO DATA(ls_other).

        "Skip comparing the same record
        IF ls_subject-%tky = ls_other-%tky.
          CONTINUE.
        ENDIF.

        IF ls_subject-CourseId    = ls_other-CourseId
           AND ls_subject-SubjectName = ls_other-SubjectName.

          APPEND VALUE #( %tky = ls_subject-%tky )
            TO failed-subject.

          APPEND VALUE #(
            %tky = ls_subject-%tky
            %msg = new_message(
                     id       = 'Z_INSTITUTE_MSG'
                     number   = '007'
                     severity = if_abap_behv_message=>severity-error )
          ) TO reported-subject.

          EXIT.   "No need to continue checking this record
        ENDIF.

      ENDLOOP.
      DATA(lv_exists) = abap_false.

      SELECT SINGLE subject_id
      FROM ziacsd_subject
      WHERE course_id = @ls_subject-CourseId
      AND subject_name = @ls_subject-SubjectName
      AND subject_id <> @ls_subject-SubjectId
      INTO @DATA(lv_dummy).

      IF sy-subrc = 0.
        lv_exists = abap_true.
      ENDIF.
      IF lv_exists = abap_true.
        APPEND VALUE #(
               %tky = ls_subject-%tky
             ) TO failed-subject.

        APPEND INITIAL LINE TO reported-subject ASSIGNING FIELD-SYMBOL(<ls_report>).

        <ls_report>-%tky = ls_subject-%tky.
        <ls_report>-%msg = new_message(
                             id       = 'Z_INSTITUTE_MSG'
                             number   = '001'
                             severity = ms-error ).
      ENDIF.

    ENDLOOP.
  ENDMETHOD.

  METHOD validateSubjectDuration.
    READ ENTITIES OF zi_iacsd_course IN LOCAL MODE
    ENTITY Subject
    FIELDS ( SubjectId Duration )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_subjects).

    LOOP AT lt_subjects INTO DATA(ls_subject).
      IF ls_subject-Duration <= 0.
        APPEND VALUE #( %tky = ls_subject-%tky ) TO failed-subject.
        APPEND VALUE #( %tky = ls_subject-%tky %msg = new_message(
                                                        id       = 'Z_INSTITUTE_MSG'
                                                        number   = '005'
                                                        severity = ms-error
                                                      ) ) TO reported-subject.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


ENDCLASS.

CLASS lhc_Course DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Course RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Course RESULT result.

    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE Course.

    METHODS earlynumbering_cba_Subject FOR NUMBERING
      IMPORTING entities FOR CREATE Course\_Subject.


    METHODS validateCourse FOR VALIDATE ON SAVE
      IMPORTING keys FOR Course~validateCourse.

    METHODS validateDuration FOR VALIDATE ON SAVE
      IMPORTING keys FOR Course~validateDuration.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Course RESULT result.

    METHODS ActivateCourse FOR MODIFY
      IMPORTING keys FOR ACTION Course~ActivateCourse RESULT result.

    METHODS DeactivateCourse FOR MODIFY
      IMPORTING keys FOR ACTION Course~DeactivateCourse RESULT result.


    METHODS get_last_number
      RETURNING VALUE(rv_last_number) TYPE i.

    METHODS get_last_subject_number
      RETURNING VALUE(rv_last_number) TYPE i.

ENDCLASS.

CLASS lhc_Course IMPLEMENTATION.

  METHOD get_instance_authorizations.
    LOOP AT keys INTO DATA(ls_key).

      APPEND VALUE #(

        %tky = ls_key-%tky

        %update = if_abap_behv=>auth-allowed

        %delete = if_abap_behv=>auth-allowed

      ) TO result.

    ENDLOOP.

  ENDMETHOD.

  METHOD get_global_authorizations.
    IF requested_authorizations-%create = if_abap_behv=>mk-on.
      result-%create = if_abap_behv=>auth-allowed.
    ENDIF.
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

  METHOD earlynumbering_cba_Subject.
    DATA lv_max TYPE i.

    lv_max = get_last_subject_number( ).

    LOOP AT entities INTO DATA(ls_parent).

      LOOP AT ls_parent-%target INTO DATA(ls_subject).

        APPEND INITIAL LINE TO mapped-subject
          ASSIGNING FIELD-SYMBOL(<ls_map>).

        <ls_map>-%cid = ls_subject-%cid.
        <ls_map>-%is_draft = ls_subject-%is_draft.

        IF ls_subject-SubjectId IS NOT INITIAL.

          <ls_map>-SubjectId = ls_subject-SubjectId.

        ELSE.

          lv_max += 1.

          <ls_map>-SubjectId = |{ lv_max }|.

        ENDIF.

      ENDLOOP.

    ENDLOOP.
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

  METHOD get_last_subject_number.
    SELECT MAX( subject_id )
    FROM ziacsd_subject
    INTO @DATA(lv_active).

    SELECT MAX( subjectid )
    FROM ziacsdsubject_d
    INTO @DATA(lv_draft).

    rv_last_number = COND i(
                    WHEN lv_active > lv_draft
                    THEN CONV i( lv_active )
                    ELSE CONV i( lv_draft ) ).
    IF rv_last_number < 200.
      rv_last_number = 200.
    ENDIF.
  ENDMETHOD.



  METHOD get_instance_features.
    READ ENTITIES OF zi_iacsd_course IN LOCAL MODE
    ENTITY Course
    FIELDS ( Status )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_course).

  LOOP AT lt_course INTO DATA(ls_course).

    APPEND VALUE #(
      %tky = ls_course-%tky

      %action-ActivateCourse =
        COND #(
          WHEN ls_course-Status = 'A'
          THEN if_abap_behv=>fc-o-disabled
          ELSE if_abap_behv=>fc-o-enabled )

      %action-DeactivateCourse =
        COND #(
          WHEN ls_course-Status = 'I'
          THEN if_abap_behv=>fc-o-disabled
          ELSE if_abap_behv=>fc-o-enabled )

    ) TO result.

  ENDLOOP.

  ENDMETHOD.

  METHOD ActivateCourse.
    READ ENTITIES OF zi_iacsd_course IN LOCAL MODE
    ENTITY Course
    FIELDS ( Status )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_course).

    DATA lt_update TYPE TABLE FOR UPDATE zi_iacsd_course.

    LOOP AT lt_course INTO DATA(ls_course).

      APPEND VALUE #( %tky = ls_course-%tky
                       Status = 'A'
                      %control-Status = if_abap_behv=>mk-on ) TO lt_update.
    ENDLOOP.

    MODIFY ENTITIES OF zi_iacsd_course IN LOCAL MODE
    ENTITY Course
    UPDATE FIELDS ( Status ) WITH lt_update.

    READ ENTITIES OF zi_iacsd_course IN LOCAL MODE
    ENTITY Course
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_result).

    result = VALUE #(
        FOR ls_result IN lt_result
        (
          %tky   = ls_result-%tky
          %param = ls_result
        )
    ).

  ENDMETHOD.

  METHOD DeactivateCourse.
    READ ENTITIES OF zi_iacsd_course IN LOCAL MODE
     ENTITY Course
     FIELDS ( Status )
     WITH CORRESPONDING #( keys )
     RESULT DATA(lt_course).

    DATA lt_update TYPE TABLE FOR UPDATE zi_iacsd_course.

    LOOP AT lt_course INTO DATA(ls_course).

      APPEND VALUE #( %tky = ls_course-%tky
                       Status = 'I'
                      %control-Status = if_abap_behv=>mk-on ) TO lt_update.
    ENDLOOP.

    MODIFY ENTITIES OF zi_iacsd_course IN LOCAL MODE
    ENTITY Course
    UPDATE FIELDS ( Status ) WITH lt_update.

    READ ENTITIES OF zi_iacsd_course IN LOCAL MODE
    ENTITY Course
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_result).

    result = VALUE #(
        FOR ls_result IN lt_result
        (
          %tky   = ls_result-%tky
          %param = ls_result
        )
    ).

  ENDMETHOD.

ENDCLASS.
