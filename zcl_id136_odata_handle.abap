*CLASS template from th_rap_query_prov_mock_impl
*nice example: https://blogs.sap.com/2019/03/01/how-to-implement-a-custom-entity-in-the-abap-restful-programming-model-using-remote-function-modules/
CLASS zcl_id136_odata_handle DEFINITION PUBLIC.
    PUBLIC SECTION.
      INTERFACES if_oo_adt_classrun.
      INTERFACES if_rap_query_provider.
  
      TYPES: tt_vendor_transaction   TYPE STANDARD TABLE OF zi_vendor_fi_transaction_id136,
             tt_contract_fi_data_cds TYPE STANDARD TABLE OF zi_contract_fi_data_id136,
             tt_contract_list        TYPE STANDARD TABLE OF zi_contract_list_id136,
             tt_goods_receipts       TYPE STANDARD TABLE OF zi_goods_receipts_id136,
             tt_payments             TYPE STANDARD TABLE OF zi_payments_id136,
             tt_coop_investments     TYPE STANDARD TABLE OF zi_coop_investments_id136,
             tt_sales_promotions     TYPE STANDARD TABLE OF zi_sales_promotions_id136,
             tt_clearing_invoices    TYPE STANDARD TABLE OF zi_clearing_invoices_id136,
             tt_ordered_prepayments  TYPE STANDARD TABLE OF zi_ordered_prepayments_id136.
    PROTECTED SECTION.
    PRIVATE SECTION.
  
      DATA mt_contract_fi_data TYPE zztcontract_fi_transactions_ws .
      CLASS-DATA mt_contract_fi_data_cds TYPE tt_contract_fi_data_cds .
      CLASS-DATA mt_goods_receipts TYPE tt_goods_receipts .
      CLASS-DATA mt_sales_promotions TYPE tt_sales_promotions .
      CLASS-DATA mt_coop_investments TYPE tt_coop_investments .
      CLASS-DATA mt_ordered_prepayments TYPE tt_ordered_prepayments .
      CLASS-DATA mt_payments TYPE tt_payments .
      CLASS-DATA mt_clearing_invoices TYPE tt_clearing_invoices .
      CLASS-DATA mt_contract_list TYPE tt_contract_list .
      CLASS-DATA mt_vendor_transaction TYPE tt_vendor_transaction .
  
      METHODS map_data_to_output_format
        IMPORTING
          !iv_vendor           TYPE lifnr
          !it_contract_fi_data TYPE zztcontract_fi_transactions_ws
          !it_contract_list    TYPE zztcontractlist_ws .
  ENDCLASS.
  
  
  
  CLASS zcl_id136_odata_handle IMPLEMENTATION.
  
  
    METHOD if_rap_query_provider~select.
      DATA: lt_contract_fi_data      TYPE zztcontract_fi_transactions_ws,
            lt_contract_list         TYPE zztcontractlist_ws,
            lt_vendor_fi_transaction TYPE STANDARD TABLE OF zi_vendor_fi_transaction_id136,
            lt_contract_list_cds     TYPE STANDARD TABLE OF zi_contract_list_id136,
            lt_contract_fi_data_cds  TYPE STANDARD TABLE OF zi_contract_fi_data_id136,
            lt_goods_receipts        TYPE STANDARD TABLE OF zi_goods_receipts_id136,
            lt_contract_range        TYPE zzostosopimus_t_range,
  
            ls_contract_fi_data_cds  TYPE zi_contract_fi_data_id136,
            ls_goods_receipts        TYPE zi_goods_receipts_id136,
  
            lv_vendor                TYPE lifnr,
            lv_year                  TYPE gjahr,
            lv_language_iso          TYPE bbp_er_langu_iso,
            lv_get_column_labels     TYPE abap_bool.
  
      DATA: ls_contract  TYPE zzscontract_fi_transactions_ws,
            ls_gr        TYPE zzsvendor_fi_transaction_ws,
            lt_contracts TYPE zztcontract_fi_transactions_ws.
      DATA(lv_top)     = io_request->get_paging( )->get_page_size( ).
      DATA(lv_skip)    = io_request->get_paging( )->get_offset( ).
  *    DATA(requested_fields)  = io_request->get_requested_elements( ).
      DATA(lv_sort_order)    = io_request->get_sort_elements( ).
      DATA v_count TYPE int8.
  
  
      TRY.
          DATA(lt_filter_conditions) = io_request->get_filter( )->get_as_ranges( ).
        CATCH cx_rap_query_filter_no_range.
      ENDTRY.
  
  
  
  
      CASE io_request->get_entity_id( ).
  
        WHEN 'ZC_CONTRACTFIDATA_ID136'.
        WHEN 'ZI_VENDOR_FI_TRANSACTION_ID136'.
  
          LOOP AT lt_filter_conditions ASSIGNING FIELD-SYMBOL(<ls_filter_cond>).
            CASE <ls_filter_cond>-name.
              WHEN 'VENDOR'.
                READ TABLE <ls_filter_cond>-range INDEX 1 INTO DATA(ls_vendor_range).
                lv_vendor = ls_vendor_range-low.
                CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                  EXPORTING
                    input  = lv_vendor
                  IMPORTING
                    output = lv_vendor.
              WHEN 'CONTRACT'.
                MOVE-CORRESPONDING <ls_filter_cond>-range TO lt_contract_range.
              WHEN 'CYEAR'.
                READ TABLE <ls_filter_cond>-range INDEX 1 INTO DATA(ls_year_range).
                lv_year = ls_year_range-low.
              WHEN 'LANGUAGEISO'.
                READ TABLE <ls_filter_cond>-range INDEX 1 INTO DATA(ls_lang_range).
                lv_language_iso = ls_lang_range-low.
              WHEN 'GETCOLUMNLABELS'.
                READ TABLE <ls_filter_cond>-range INDEX 1 INTO DATA(ls_get_cl).
                lv_get_column_labels = ls_get_cl-low.
            ENDCASE.
          ENDLOOP.
  
          DATA(lt_parameters) = io_request->get_parameters( ).
  
          CALL FUNCTION 'Z_MLO_GETVENDORFITRANSACT_ODAT'
            EXPORTING
              i_vendor          = lv_vendor
              i_year            = lv_year
              i_getcolumnlabels = lv_get_column_labels
              i_language_iso    = lv_language_iso
              it_contract_range = lt_contract_range
            IMPORTING
              et_contractfidata = lt_contract_fi_data
              et_contractlist   = lt_contract_list.
  
          " Always return only 1 record of vendor fi transaction
          IF io_request->is_total_numb_of_rec_requested(  ).
            io_response->set_total_number_of_records( 1 ).
          ENDIF.
  *        " For testing
          APPEND INITIAL LINE TO lt_vendor_fi_transaction ASSIGNING FIELD-SYMBOL(<ls_vft>).
          <ls_vft>-vendor = lv_vendor.
          <ls_vft>-CYear = lv_year.
  
          " Map data to output maps the data and ALSO sets mt_* attributes, so the calculations are only done once
          " The data for all the other entities is already calculated but it's set later (below, in other case branches)
          me->map_data_to_output_format(
            EXPORTING
              iv_vendor = lv_vendor
              it_contract_fi_data = lt_contract_fi_data
              it_contract_list = lt_contract_list ).
  
          io_response->set_data( lt_vendor_fi_transaction ).
        WHEN 'ZI_CONTRACT_LIST_ID136'.
          io_response->set_data( mt_contract_list ).
        WHEN 'ZI_CONTRACT_FI_DATA_ID136'.
  
          io_response->set_data( mt_contract_fi_data_cds ).
  
        WHEN 'ZI_GOODS_RECEIPTS_ID136'.
          io_response->set_data( mt_goods_receipts ).
        WHEN 'ZI_PAYMENTS_ID136'.
          io_response->set_data( mt_payments ).
        WHEN 'ZI_CLEARING_INVOICES_ID136'.
          io_response->set_data( mt_clearing_invoices ).
        WHEN 'ZI_ORDERED_PREPAYMENTS_ID136'.
          io_response->set_data( mt_ordered_prepayments ).
        WHEN 'ZI_SALES_PROMOTIONS_ID136'.
          io_response->set_data( mt_sales_promotions ).
        WHEN 'ZI_COOP_INVESTMENTS_ID136'.
          io_response->set_data( mt_coop_investments ).
      ENDCASE.
  
  
    ENDMETHOD.
  
  
    METHOD if_oo_adt_classrun~main.
  
      DATA count TYPE int8.
      DATA filter_conditions  TYPE if_rap_query_filter=>tt_name_range_pairs .
      DATA ranges_table TYPE if_rap_query_filter=>tt_range_option .
      ranges_table = VALUE #( (  sign = 'I' option = 'GE' low = '070015' ) ).
      filter_conditions = VALUE #( ( name = 'AGENCYID'  range = ranges_table ) ).
  
      TRY.
  
        CATCH cx_root INTO DATA(exception).
          out->write( cl_message_helper=>get_latest_t100_exception( exception )->if_message~get_longtext( ) ).
      ENDTRY.
  
  
    ENDMETHOD.
  
  
    METHOD map_data_to_output_format.
  
      DATA: lt_contract_fi_data_cds TYPE STANDARD TABLE OF zi_contract_fi_data_id136,
            lt_contract_list        TYPE STANDARD TABLE OF zi_contract_list_id136,
            lt_goods_receipts       TYPE STANDARD TABLE OF zi_goods_receipts_id136,
            lt_payments             TYPE STANDARD TABLE OF zi_payments_id136,
            lt_coop_investments     TYPE STANDARD TABLE OF zi_coop_investments_id136,
            lt_sales_promotions     TYPE STANDARD TABLE OF zi_sales_promotions_id136,
            lt_clearing_invoices    TYPE STANDARD TABLE OF zi_clearing_invoices_id136,
            lt_ordered_prepayments  TYPE STANDARD TABLE OF zi_ordered_prepayments_id136.
  
      " Clear static attributes, we store data in static attributes so they are persistent (buffered)
      CLEAR: mt_contract_fi_data_cds, mt_clearing_invoices, mt_coop_investments, mt_goods_receipts, mt_payments, mt_ordered_prepayments, mt_sales_promotions, mt_contract_list.
  
      LOOP AT it_contract_fi_data ASSIGNING FIELD-SYMBOL(<ls_contract_fi_data>).
        APPEND INITIAL LINE TO lt_contract_fi_data_cds ASSIGNING FIELD-SYMBOL(<ls_cfd>).
        MOVE-CORRESPONDING <ls_contract_fi_data> TO <ls_cfd>.
        <ls_cfd>-vendor = iv_vendor.
        <ls_cfd>-hastransactions = <ls_contract_fi_data>-has_transactions.
        <ls_cfd>-fidatadisabled = <ls_contract_fi_data>-fi_data_disabled.
  
        LOOP AT <ls_contract_fi_data>-goodsreceipts ASSIGNING FIELD-SYMBOL(<ls_gr>).
          APPEND INITIAL LINE TO lt_goods_receipts ASSIGNING FIELD-SYMBOL(<ls_gr_out>).
          <ls_gr_out>-contract = <ls_contract_fi_data>-contract.
          <ls_gr_out>-vendor = iv_vendor.
          MOVE-CORRESPONDING <ls_gr> TO <ls_gr_out>.
        ENDLOOP.
  
        LOOP AT <ls_contract_fi_data>-payments ASSIGNING FIELD-SYMBOL(<ls_payments>).
          APPEND INITIAL LINE TO lt_payments ASSIGNING FIELD-SYMBOL(<ls_payments_out>).
          <ls_payments_out>-contract = <ls_contract_fi_data>-contract.
          <ls_payments_out>-vendor = iv_vendor.
          MOVE-CORRESPONDING <ls_payments> TO <ls_payments_out>.
        ENDLOOP.
  
        LOOP AT <ls_contract_fi_data>-coopinvestments ASSIGNING FIELD-SYMBOL(<ls_coop_inv>).
          APPEND INITIAL LINE TO lt_coop_investments ASSIGNING FIELD-SYMBOL(<ls_coop_inv_out>).
          <ls_coop_inv_out>-contract = <ls_contract_fi_data>-contract.
          <ls_coop_inv_out>-vendor = iv_vendor.
          MOVE-CORRESPONDING <ls_coop_inv> TO <ls_coop_inv_out>.
        ENDLOOP.
  
        LOOP AT <ls_contract_fi_data>-clearinginvoices ASSIGNING FIELD-SYMBOL(<ls_clearing_invoice>).
          APPEND INITIAL LINE TO lt_clearing_invoices ASSIGNING FIELD-SYMBOL(<ls_clearing_invoice_out>).
          <ls_clearing_invoice_out>-contract = <ls_contract_fi_data>-contract.
          <ls_clearing_invoice_out>-vendor = iv_vendor.
          MOVE-CORRESPONDING <ls_clearing_invoice> TO <ls_clearing_invoice_out>.
        ENDLOOP.
  
        LOOP AT <ls_contract_fi_data>-salespromotions ASSIGNING FIELD-SYMBOL(<ls_sales_promotion>).
          APPEND INITIAL LINE TO lt_sales_promotions ASSIGNING FIELD-SYMBOL(<ls_sales_promotion_out>).
          <ls_sales_promotion_out>-contract = <ls_contract_fi_data>-contract.
          <ls_sales_promotion_out>-vendor = iv_vendor.
          MOVE-CORRESPONDING <ls_sales_promotion> TO <ls_sales_promotion_out>.
        ENDLOOP.
  
        LOOP AT <ls_contract_fi_data>-orderedprepayments ASSIGNING FIELD-SYMBOL(<ls_ord_prepayments>).
          APPEND INITIAL LINE TO lt_ordered_prepayments ASSIGNING FIELD-SYMBOL(<ls_ord_prepayments_out>).
          <ls_ord_prepayments_out>-contract = <ls_contract_fi_data>-contract.
          <ls_ord_prepayments_out>-vendor = iv_vendor.
          MOVE-CORRESPONDING <ls_ord_prepayments> TO <ls_ord_prepayments_out>.
        ENDLOOP.
  
      ENDLOOP.
  
      LOOP AT it_contract_list ASSIGNING FIELD-SYMBOL(<ls_contract_list>).
        APPEND INITIAL LINE TO lt_contract_list ASSIGNING FIELD-SYMBOL(<ls_cl>).
        MOVE-CORRESPONDING <ls_contract_list> TO <ls_cl>.
        <ls_cl>-vendor = iv_vendor.
        <ls_cl>-ordertypemlo = <ls_contract_list>-ordertype_mlo.
        <ls_cl>-ordertypetextmlo = <ls_contract_list>-ordertypetext_mlo.
      ENDLOOP.
  
      " Set static attributes (tables)
      mt_contract_fi_data_cds = lt_contract_fi_data_cds.
      mt_contract_list = lt_contract_list.
      mt_goods_receipts = lt_goods_receipts.
      mt_payments = lt_payments.
      mt_sales_promotions = lt_sales_promotions.
      mt_ordered_prepayments = lt_ordered_prepayments.
      mt_clearing_invoices = lt_clearing_invoices.
      mt_coop_investments = lt_coop_investments.
  
    ENDMETHOD.
  ENDCLASS.