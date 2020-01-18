/// https://services2.arcgis.com/aIrBD8yn1TDTEXoz/arcgis/rest/services/WinterCountyConditions_View/FeatureServer
struct IllinoisCountyWinterRoadConditions: Codable {
    let OBJECTID: Int
    let COUNTY_NAM: String?
    let CNTY_CODE: String?
    let RD_COND: Int?
    let Cond_Desc: String?
    let Shape__Area: Double?
    let Shape__Length: Double?
}
