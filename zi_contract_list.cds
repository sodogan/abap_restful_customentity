@EndUserText.label: 'CDS view for ContractFiData'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_ID136_ODATA_HANDLE'
define custom entity ZI_CONTRACT_LIST
{
  key Contract             : abap.numc(9);
  key Vendor              : abap.char(10);
      ContractDecade       : abap.numc(1);
      OrderType            : abap.char(4);
      OrderTypeText        : abap.char(20);
      OrderTypeMlo         : abap.char(1);
      OrderTypeTextMlo     : abap.char(30);
      OrderDate            : abap.dats(8);
      HasTransactions      : abap.char(1);
      FiDataDisabled       : abap.char(1);
      FinalMeasurementDone : abap.char(1);
      @Semantics.amount.currencyCode: 'Currency'
      EstimatedValue       : abap.dec( 15, 2 );
      @Semantics.currencyCode
      Currency             : abap.cuky( 5 );
      HasOtherPayee        : abap.char(1);
      OtherPayeeName       : abap.char(30);
      ErrorOcurred         : abap.char(1);
      _VendorFiTransaction : association to parent ZI_VENDOR_FI_TRANSACTION on $projection.Vendor = _VendorFiTransaction.Vendor;
}
