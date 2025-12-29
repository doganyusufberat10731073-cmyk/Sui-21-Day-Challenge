/// DAY 11: TaskBoard & Address Type


module challenge::day_11 {
    use std::string::{Self, String};

    // Copy from day_10: TaskStatus enum and Task struct
    public enum TaskStatus has copy, drop, store {
        Open,
        Completed,
    }

    public struct Task has copy, drop, store {
        title: String,
        reward: u64,
        status: TaskStatus,
    }

    // Gorev panosu
    // Bu yapi gorevleri tutacak
    public struct TaskBoard has drop, store {
        owner: address,  // Panonun sahibi kim? (0x..)
        tasks: vector<Task>,  // Gorevler listesi

    }
    
    // Fonksiyonlar
    // 1. Yeni gorev
    public fun new_task(title: String, reward: u64): Task {
        Task {
            title,
            reward,
            status: TaskStatus::Open,
        }
    }

    // 2. Helper (Byte -> String)
    public fun create_task(title_bytes: vector<u8>, reward: u64): Task {
        new_task(string::utf8(title_bytes), reward)

    }

    // 3. Panoyu kur
    // Sahibi (owner) parametre olarak aliyoruz
    public fun new_board(owner: address): TaskBoard {
        TaskBoard {
            owner,  // Sahibi ata
            tasks: vector::empty()  // Bos bir liste ile basla
        }
    }

    // 4. Panoya gorev ekle
    // Ponoyu degistirecegimiz icin &mut kullaniyoruz
    public fun add_task(board: &mut TaskBoard, task: Task) {
        board.tasks.push_back(task);

    }

    // Test
    #[test]
    fun test_board_flow() {
        // A. Sahte bir adres uydurdum (Test icin)
        let owner_addr = @0xCAFE;

        // B. Panoyu kuralim
        let mut board = new_board(owner_addr);

        // C. Gorevleri hatirlayalim
        let task1 = create_task(b"Move Ogren", 100);
        let task2 = create_task(b"Pano Yap", 200);

        // D. Panoya ekleyelim
        add_task(&mut board, task1);
        add_task(&mut board, task2);

        // E. Kontrol zamani
        // 1. Sahip dogru mu?
        assert!(board.owner == owner_addr, 0);

        // 2. Iceride 2 gorev var mi?
        assert!(board.tasks.length() == 2,1);
    }

    
    }


