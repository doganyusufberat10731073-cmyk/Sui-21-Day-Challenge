/// DAY 5: Control Flow & Mark Habit as Done
/// 
/// Today you will:
/// 1. Learn if/else statements
/// 2. Learn how to access vector elements
/// 3. Write a function to mark a habit as completed

module challenge::day_05 {
    use std::string::{Self, String};
   

    // Copy from day_04
    public struct Habit has copy, drop, store {
        name: String,
        completed: bool,
    }

    public struct HabitList has drop, store {
        habits: vector<Habit>,
    }

    public fun new_habit(name_bytes: vector<u8>): Habit {
        Habit {
            name: string::utf8(name_bytes),
            completed: false,
        }
    }

    public fun empty_list(): HabitList {
        HabitList {
            habits: vector::empty(),
        }
    }
    
    // Ekleme
    public fun add_habit(list: &mut HabitList, habit: Habit) {
        vector::push_back(&mut list.habits, habit);
    }

    // Mantik: Verilen sira numarasini bul ve completed
    public fun complete_habit(list: &mut HabitList, index: u64) {
        // 1. Guvenlik kontrolu
        // Eger istenen sira numrasi listenin boyunu asmiyorsa islem ac
        if (index < vector::length(&list.habits)) {

            // 2. Degistirmek icin al (BORROW_MUT)
            // borrow_mut komutu o kutuyu acip icini degistirmemize izin verir
            let habit_to_update = vector::borrow_mut(&mut list.habits, index);

            // 3. Tik at
            habit_to_update.completed = true;
        }
    }

    // Test
    #[test]
    fun test_complete_habit() {
        // 1. Ortami hazirla
        let mut list = empty_list();
        let habit = new_habit(b"Sabah kosusu");
        add_habit(&mut list, habit);

        // 2. Tamamla 
        complete_habit(&mut list, 0);

        // 3. Kontrol et (Gercekten true oldu mu)
        // Okumak icin borrow kullaniyoruz 
        let check_habit = vector::borrow(&list.habits, 0);
        assert!(check_habit.completed == true, 0);
    }

    // TODO: Write a function 'complete_habit' that:
    // - Takes list: &mut HabitList and index: u64
    // - Checks if index is valid (less than vector length)
    // - If valid, marks that habit's completed field as true
    // Use vector::length() to get the length
    // Use vector::borrow_mut() to get a mutable reference to an element
    // public fun complete_habit(list: &mut HabitList, index: u64) {
    //     // Your code here
    //     // Hint: if (index < length) { ... }
    // }
}

