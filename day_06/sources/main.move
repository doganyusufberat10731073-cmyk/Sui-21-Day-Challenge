module challenge::day_06 {
    use std::string::{Self, String};
    // use std::vector; <-- Sildik, uyarilar gitti.

    // --- YAPILAR ---
    public struct Habit has copy, drop, store {
        name: String,
        completed: bool,
    }

    public struct HabitList has copy, drop, store {
        habits: vector<Habit>,
    }

    // --- FONKSIYONLAR ---

    // GOREV 2: new_habit (Sadece String kabul eder)
    public fun new_habit(name: String): Habit {
        Habit {
            name, 
            completed: false,
        }
    }

    // GOREV 3: make_habit (Byte -> String cevirici)
    public fun make_habit(name_bytes: vector<u8>): Habit {
        let name_str = string::utf8(name_bytes);
        new_habit(name_str)
    }

    public fun empty_list(): HabitList {
        HabitList {
            habits: vector::empty()
        }
    }

    
    public fun add_habit(list: &mut HabitList, habit: Habit) {
        list.habits.push_back(habit);
    }

    public fun complete_habit(list: &mut HabitList, index: u64) {
        if (index < list.habits.length()) {
            let habit_to_update = list.habits.borrow_mut(index);
            habit_to_update.completed = true;
        }
    }

    // --- TESTLER ---
    #[test]
    fun test_string_conversion() {
        let mut list = empty_list();
        
        // Byte dizisini (b"...") String'e ceviren fonksiyonu kullaniyoruz
        let habit1 = make_habit(b"Sui String Test"); 
        
        // Artik hata vermeyecek cunku add_habit yukarida tanimli
        add_habit(&mut list, habit1);
        
        // Uzunluk kontrolu
        assert!(list.habits.length() == 1, 0);
    }
}