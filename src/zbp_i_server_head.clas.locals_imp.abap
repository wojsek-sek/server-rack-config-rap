CLASS lhc_Server DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Server RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Server RESULT result.

ENDCLASS.

CLASS lhc_Server IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

ENDCLASS.

CLASS lhc__Items DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS calculateTotals FOR DETERMINE ON MODIFY
      IMPORTING keys FOR _Items~calculateTotals.

ENDCLASS.

CLASS lhc__Items IMPLEMENTATION.

  METHOD calculateTotals.
    READ ENTITIES OF zi_server_head IN LOCAL MODE
      ENTITY _Items BY \_Server
      FIELDS ( ConfigUuid )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_racks).

    " Usuwamy duplikaty (jeśli zmieniono 3 komponenty w 1 szafie, chcemy przeliczyć szafę tylko raz)
    SORT lt_racks BY ConfigUuid.
    DELETE ADJACENT DUPLICATES FROM lt_racks COMPARING ConfigUuid.

    " // English comment: Loop through each unique Parent (Rack) to recalculate its totals based on its children.
    " 2. Przeliczamy sumy dla każdej unikalnej Szafy
    LOOP AT lt_racks INTO DATA(ls_rack).

      " Odczytaj wszystkie Komponenty (Dzieci) należące do tej Szafy
      READ ENTITIES OF zi_server_head IN LOCAL MODE
        ENTITY Server BY \_Items
        FIELDS ( Quantity PricePerUnit PowerWPerUnit SpaceUPerUnit )
        WITH VALUE #( ( %tky = ls_rack-%tky ) )
        RESULT DATA(lt_items).

      " Zmienne pomocnicze do sumowania
      DATA: lv_total_price TYPE zserverrack-total_price, " Używamy typu z naszej bazy
            lv_total_power TYPE i,
            lv_total_space TYPE i.

      CLEAR: lv_total_price, lv_total_power, lv_total_space.

      " Sumowanie wartości (Cena = Ilość * Cena za sztukę)
      LOOP AT lt_items INTO DATA(ls_item).
        lv_total_price += ls_item-Quantity * ls_item-PricePerUnit.
        lv_total_power += ls_item-Quantity * ls_item-PowerWPerUnit.
        lv_total_space += ls_item-Quantity * ls_item-SpaceUPerUnit.
      ENDLOOP.

      " // English comment: Use MODIFY ENTITIES IN LOCAL MODE to update the Draft/Active buffer.
      " // Local mode bypasses authorization checks since this is a system calculation.
      " 3. Zaktualizuj Nagłówek (Szafę) nowymi sumami
      MODIFY ENTITIES OF zi_server_head IN LOCAL MODE
        ENTITY Server
        UPDATE
        FIELDS ( TotalPrice TotalPowerW TotalSpaceU )
        WITH VALUE #( ( %tky = ls_rack-%tky
                        TotalPrice  = lv_total_price
                        TotalPowerW = lv_total_power
                        TotalSpaceU = lv_total_space ) ).

    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
