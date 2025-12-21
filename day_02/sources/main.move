/// DAY 2: Primitive Types & Simple Functions
/// 
/// Today you will:
/// 1. Practice with primitive types (u64, bool)
/// 2. Write your first function
/// 3. Write your first test

module challenge::day_02 {
    // 1. Test aracini iceri aliyoruz (Sadece test yaparken calisir)
    #[test_only]
    use std::unit_test::assert_eq;
    

    // a ve b isminde iki sayi alir, sonuc olarak yine (u64) verir
    public fun sum(a: u64, b: u64): u64 {
        a + b  // Move dilinde noktoli virgul return dondur demektir
    }
     
    // and returns their sum
    // public fun sum(a: u64, b: u64): u64 {
    //     // Your code here
    // }

    // Test 
    #[test]
    fun test_sum() {
        // Fonksiyonu dene  1 + 2 kac eder?
        let result = sum(1,2);

        // Sonucun 3 oldugunu dogrula
        assert_eq!(result, 3);
    }

    // TODO: Write a test function that checks sum(1, 2) == 3
    // #[test]
    // fun test_sum() {
    //     // Your code here
    // }
}

