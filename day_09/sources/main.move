/// DAY 9: Enums & TaskStatus


module challenge::day_09 {
    use std::string::{Self, String};


    // Enum
    // Gorev durumlarini kontrol eden etiketler
    public enum TaskStatus has copy, drop, store {
        Open,
        Completed,
    }


    // Yapilar (structs)
    public struct Task has copy, drop, store {
        title: String,
        reward: u64,
        status: TaskStatus,  // Artik bool degil enum oldu
    }

    // Fonksiyonlar
    // 1. Ana kurucu (string)
    public fun new_task(title: String, reward: u64): Task {
        Task {
            title,
            reward,
            status: TaskStatus::Open,  // Varsayilan olarak open baslar
        }
    }

    // 2. Yardimci Fonksiyon (Bye dizisi ile day8 den miras alacaz)
    public fun create_task(title_bytes: vector<u8>, reward: u64): Task {
        new_task(string::utf8(title_bytes), reward)

    }

    // 3. Durum kontrol 
    public fun is_open(task: &Task): bool {
        // Gorevin durumu open mi diye bakar
        task.status == TaskStatus::Open

    }

    // Test
    #[test]
    fun test_task_status() {
        // Gorevi olustur
        let task = create_task(b"Enum Ogren", 50);

        // 1. Kontrol: Gorev acik mi?
        assert!(is_open(&task) == true, 0);

        // 2. Kontrol: Status dogru atanmis mi?
        // Dogrudan enum karsilastirmasi yapiyoruz
        assert!(task.status == TaskStatus::Open, 1);
    }

}

    

