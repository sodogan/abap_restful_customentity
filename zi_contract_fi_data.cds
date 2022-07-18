@EndUserText.label: 'CDS view for ContractFiData'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_ID136_ODATA_HANDLE'
define custom entity zi_contract_fi_data
{
  key Contract            : abap.numc(9);
  key Vendor              : abap.char(10);
      CYear               : abap.numc(4);
      Language            : abap.char(2);
      ContractDecade      : abap.numc(1);
      HasTransactions     : abap.char(1);
      FiDataDisabled      : abap.char(1);
      ErrorOcurred        : abap.char(1);
      _GoodsReceipts      : composition [1..*] of ZI_GOODS_RECEIPTS_ID136;
      _Payments           : composition [1..*] of ZI_PAYMENTS_ID136;
      _CoopInvestments    : composition [1..*] of ZI_COOP_INVESTMENTS_ID136;
      _SalesPromotions    : composition [1..*] of ZI_SALES_PROMOTIONS_ID136;
      _ClearingInvoices   : composition [1..*] of ZI_CLEARING_INVOICES_ID136;
      _OrderedPrepayments : composition [1..*] of ZI_ORDERED_PREPAYMENTS_ID136;
      _VendorFiTransaction : association to parent ZI_VENDOR_FI_TRANSACTION_ID136 on $projection.Vendor = _VendorFiTransaction.Vendor;
}
