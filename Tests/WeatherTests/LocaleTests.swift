import XCTest
@testable import Weather

final class LocaleTests: XCTestCase {
    
}

extension LocaleTests {
    func testLanguage() {
        XCTAssertEqual(Locale(identifier: "ar_EG").language, .ar)
        XCTAssertEqual(Locale(identifier: "az_Latn").language, .az)
        XCTAssertEqual(Locale(identifier: "be_BY").language, .be)
        XCTAssertEqual(Locale(identifier: "bg_BG").language, .bg)
        XCTAssertEqual(Locale(identifier: "bs_BA").language, .bs)
        XCTAssertEqual(Locale(identifier: "ca_ES").language, .ca)
        XCTAssertEqual(Locale(identifier: "cs_CZ").language, .cs)
        XCTAssertEqual(Locale(identifier: "da_DK").language, .da)
        XCTAssertEqual(Locale(identifier: "de_LI").language, .de)
        XCTAssertEqual(Locale(identifier: "el_GR").language, .el)
        XCTAssertEqual(Locale(identifier: "en_US").language, .en)
        XCTAssertEqual(Locale(identifier: "es_ES").language, .es)
        XCTAssertEqual(Locale(identifier: "et_EE").language, .et)
        XCTAssertEqual(Locale(identifier: "fi_FI").language, .fi)
        XCTAssertEqual(Locale(identifier: "fr_FR").language, .fr)
        XCTAssertEqual(Locale(identifier: "hr_HR").language, .hr)
        XCTAssertEqual(Locale(identifier: "hu_HU").language, .hu)
        XCTAssertEqual(Locale(identifier: "id_ID").language, .id)
        XCTAssertEqual(Locale(identifier: "is_IS").language, .is)
        XCTAssertEqual(Locale(identifier: "it_IT").language, .it)
        XCTAssertEqual(Locale(identifier: "ja_JP").language, .ja)
        XCTAssertEqual(Locale(identifier: "ka_GE").language, .ka)
        XCTAssertEqual(Locale(identifier: "kw_GB").language, .kw)
        XCTAssertEqual(Locale(identifier: "nb_NO").language, .nb)
        XCTAssertEqual(Locale(identifier: "nl_NL").language, .nl)
        XCTAssertEqual(Locale(identifier: "pl_PL").language, .pl)
        XCTAssertEqual(Locale(identifier: "pt_PT").language, .pt)
        XCTAssertEqual(Locale(identifier: "ro_RO").language, .ro)
        XCTAssertEqual(Locale(identifier: "ru_RU").language, .ru)
        XCTAssertEqual(Locale(identifier: "sk_SK").language, .sk)
        XCTAssertEqual(Locale(identifier: "sl_SI").language, .sl)
        XCTAssertEqual(Locale(identifier: "sr_Latn").language, .sr)
        XCTAssertEqual(Locale(identifier: "sv_SE").language, .sv)
        XCTAssertEqual(Locale(identifier: "tet").language, .tet)
        XCTAssertEqual(Locale(identifier: "tr_TR").language, .tr)
        XCTAssertEqual(Locale(identifier: "uk_UA").language, .uk)
        XCTAssertEqual(Locale(identifier: "zh_Hans").language, .zh)
        XCTAssertEqual(Locale(identifier: "zh_Hant").language, .zht)
    }
}
