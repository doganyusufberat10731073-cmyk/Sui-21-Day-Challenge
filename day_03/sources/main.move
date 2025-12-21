/// DAY 3: Structs (Habit Model Skeleton)
/// 
/// Today you will:
/// 1. Learn about structs
/// 2. Create a Habit struct
/// 3. Write a constructor function

module challenge::day_03 {
    #[test_only]
    use std::unit_test::assert_eq;

    // Gorev 1: Habit yapisini tanimla
    public struct Habit has copy, drop {
        name: vector<u8>,  // Aliskanlik ismi 
        completed: bool,  // Tamamlandi mi
    }

    // Gorev 2: Yeni aliskanlik
    public fun new_habit(name: vector<u8>): Habit {
        Habit {
            name: name,  // Gelen ismi kullan
            completed: false  // Varsayilan olarak baslasin 
        }
    }

    
    // - name: vector<u8> (we'll use String later)
    // - completed: bool
    // Add 'copy' and 'drop' abilities
    // public struct Habit has copy, drop {
    //     // Your fields here
    // }

    // Test
    #[test]
    fun test_create_habit() {
        let name = b"Erken Kalk";  // b"" harfleri byte dizisine cevirir
        let my_habit = new_habit(name);

        // Yeni olusturulan aliskanlik complated false olmali
        assert_eq!(my_habit.completed, false);
    }

    
    // that takes a name (vector<u8>) and returns a Habit
    // public fun new_habit(name: vector<u8>): Habit {
    //     // Your code here
    // }
}

