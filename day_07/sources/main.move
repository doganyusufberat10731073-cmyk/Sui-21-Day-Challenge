/// DAY 7: Unit Tests for Habit Tracker
///
/// Today you will:
/// 1. Learn how to write tests in Move
/// 2. Write tests for your habit tracker
/// 3. Use assert! macro
///
/// Note: You can copy code from day_06/sources/solution.move if needed

module challenge::day_07 {
    use std::string::{Self, String};

    // Copy from day_06: Habit struct with String
    public struct Habit has copy, drop, store {
        name: String,
        completed: bool,
    }

    public struct HabitList has drop, copy, store{
        habits: vector<Habit>,
    }

    public fun new_habit(name: String): Habit {
        Habit {
            name,
            completed: false,
        }
    }

    // make_habit Byte dizisini (b"...") stringe cevirip hsbit yapar
    public fun make_habit(name_bytes: vector<u8>): Habit {
       new_habit(string::utf8(name_bytes))
    }
    
    // empty_list bos liste
    public fun empty_list(): HabitList {
        HabitList {
            habits: vector::empty(),
        }
    }
    
    // add_habit: listeye ekle
    public fun add_habit(list: &mut HabitList, habit: Habit) {
        list.habits.push_back(habit);
    }
    
    // complete_habit tamamlandi isaretle
    public fun complete_habit(list: &mut HabitList, index: u64) {
        if (index < list.habits.length()) {
            let habit_to_update = list.habits.borrow_mut(index);
            habit_to_update.completed = true;
        }
    }

    // Testler
    // Test 1: Listeye dogru sekilde ekleme yapılıyor mu?
    #[test]
    fun test_add_habits() {
        // A. ortami kur
        let mut list = empty_list();

        // B. Verileri hazirla (make_habit)
        let habit1 = make_habit(b"Spor Yap");
        let habit2 = make_habit(b"Kitap Oku");

        // C. islem yap
        add_habit(&mut list, habit1);
        add_habit(&mut list, habit2);

        // D. Kontrol et
        assert!(list.habits.length() == 2, 0);

    }

    // Test 2: Tamamlandi isateri
    #[test]
    fun test_complete_habit() {
        // A. Ortami kur
        let mut list = empty_list();
        let habit = make_habit(b"Kod Yaz");
        add_habit(&mut list, habit);

        // B. İslem Yap (0. Siradakini tamamla)
        complete_habit(&mut list, 0);

        // C. Kontrol et
        let completed_habit = list.habits.borrow(0);

        // Beklenti. completd == true olmaili
        assert!(completed_habit.completed == true, 1);
    }

    // Note: assert! is a built-in macro in Move 2024 - no import needed!

    // TODO: Write a test 'test_add_habits' that:
    // - Creates an empty list
    // - Adds 1-2 habits
    // - Checks that the list length is correct
    // #[test]
    // fun test_add_habits() {
    //     // Your code here
    //     // Use b"Exercise".to_string() to create a String
    // }

    // TODO: Write a test 'test_complete_habit' that:
    // - Creates a list and adds a habit
    // - Completes the habit
    // - Checks that completed == true
    // #[test]
    // fun test_complete_habit() {
    //     // Your code here
    // }
}

