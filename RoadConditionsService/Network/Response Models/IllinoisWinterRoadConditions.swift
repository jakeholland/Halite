/// https://services2.arcgis.com/aIrBD8yn1TDTEXoz/ArcGIS/rest/services/Winter_Road_Conditions_View/FeatureServer/0
struct IllinoisWinterRoadConditionsResponse: Codable {
    let OBJECTID_12: Int
    let OBJECT_ID: Double?
    let COND_ID: String?
    let RD_COND: Double?
    let TOLLWAY: Double?
    let YARDS: String?
    let Id: Int?
    let Route: String?
    let County: String?
    let Cond_Desc: String?
    let RPT_DESC: String?
    let DISTRICT: Int?
    let LastUpdate: String?
    let SHAPE__Length: Double?
}
