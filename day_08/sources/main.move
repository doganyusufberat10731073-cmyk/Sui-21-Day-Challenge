/// DAY 8: New Module & Simple Task Struct
/// 
/// Today you will:
/// 1. Start a new project: Task Bounty Board
/// 2. Create a Task struct
/// 3. Write a constructor function

module challenge::day_08 {
    use std::string::{Self, String};

    // Yapilar
    // Gorev Yapisi
    // title: Gorevin adi
    // reward: Odul mikatri (u64 yani pozitif tam sayi)
    // done: Yapildi mi?
    public struct Task has copy, drop, store {
        title: String,
        reward: u64,
        done: bool,

    }

    // Fonksiyonlar
    // 1.Ana kurucu fonksiyon (Sting kabul eder)
    public fun new_task(title: String, reward: u64): Task {
        Task {
            title,
            reward,
            done: false,  // Varsayilan olarak yapilmadi
        }
    }

    // 2. Yardimci fonksiyon (Byte dizisi b"..." kabul eder)
    // Bu sayede testlerle ugrasmiyoruz
    public fun create_task(title_bytes: vector<u8>, reward: u64): Task {
        new_task(string::utf8(title_bytes), reward)  // Stringe çevirir

    }

    // Test
    #[test]
    fun test_create_task() {
        // 100 Puanlik bir gorev olusturalim
        let task = create_task(b"Move Ogren", 100);

        // Kontrol 
        assert!(task.reward == 100, 0);
        assert!(task.done == false, 1);
    }

    // TODO: Define a struct called 'Task' with:
    // - title: String
    // - reward: u64
    // - done: bool
    // Add 'copy' and 'drop' abilities
    // public struct Task has copy, drop {
    //     // Your fields here
    // }

    // TODO: Write a constructor function 'new_task'
    // that takes title and reward, returns a Task with done = false
    // public fun new_task(title: String, reward: u64): Task {
    //     // Your code here
    // }
}

