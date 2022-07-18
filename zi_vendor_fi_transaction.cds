@EndUserText.label: 'CDS view for ContractFiData'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_ID136_ODATA_HANDLE'
define root custom entity ZI_VENDOR_FI_TRANSACTION
//with parameters p_contract : abap.numc(9)
{
  key Vendor          : abap.char(10);
      CYear           : abap.numc(4);
      Contract        : abap.numc(9);
      _ContractFiData : composition [1..*] of zi_contract_fi_data_id136;
      _ContractList   : composition [1..*] of ZI_CONTRACT_LIST_ID136;
      _ColumnLabels   : composition [1..*] of ZI_COLUMN_LABELS_HEAD_ID136;
}
