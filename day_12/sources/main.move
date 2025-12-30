/// DAY 12: Option for Task Lookup

module challenge::day_12 {
    use std::string::{Self, String};
    use std::option::{Self, Option};  // Yeni kutuphane: Option

    // Enum ve struct
    public enum TaskStatus has copy, drop, store {
        Open,
        Completed,
    }

    public struct Task has drop, store {
        title: String,
        reward: u64,
        status: TaskStatus,
    }

    public struct TaskBoard has drop, store {
        owner: address,
        tasks: vector<Task>,
    }
    
    // Fonksiyonlar
    public fun new_task(title: String, reward: u64): Task {
        Task {
            title,
            reward,
            status: TaskStatus::Open,
        }
    }

    public fun create_task(title_bytes: vector<u8>, reward: u64): Task {
        new_task(string::utf8(title_bytes), reward)

    }

    public fun new_board(owner: address): TaskBoard {
        TaskBoard {
            owner,
            tasks: vector::empty(),
        }
    }

    public fun add_task(board: &mut TaskBoard, task: Task) {
        board.tasks.push_back(task);
    }

    // Yeni fonksiyon: Gorev bulucu
    // Girdi: Pano ve aranacak baslik (string)
    // Cikti: Option<u64> -> Yeni belki u64 belki hicbir sey
    // Bu fonksiyon panoda tek tek gezer
    public fun find_task_by_title(board: &TaskBoard, title: String): Option<u64> {
        let len = board.tasks.length();  // Panoda toplam kac gorev var?
        let mut i = 0;  // Su an kacinci goreve bakiyorum

        // Klasik while dongusu, bastan sona kadar gez
        while (i < len) {
            let task = board.tasks.borrow(i);  // i. siradaki goreve bak

            // Eger basliklar ayniysa
            if (task.title == title) {
                return option::some(i)  // Buldum indeksi paketle ve don

            };

            i = i + 1;  // Bir sonrakine gec
        };

        // Dongu bitti, hala buradaysak bulamamisiz demektir
        option::none()  // Bos don

    } 

    // Test
    #[test]
    fun test_search_task() {
        let owner_addr = @0xCAFE;
        let mut board = new_board(owner_addr);

        // Panoya 2 gorev ekleyelim
        add_task(&mut board, create_task(b"Move", 100));  // index 0
        add_task(&mut board, create_task(b"Sui", 200));  // index 1

        // Senaryo 1: Var olan bir gorevi ara ("Sui")
        let search_title = string::utf8(b"Sui");
        let result = find_task_by_title(&board, search_title);

        // Sonuc bos degil (is_some) ve ici 1 olmali
        assert!(result.is_some(), 0);
        assert!(result.borrow() == &1, 1);

        // Senaryo 2: Olmayan bir gorevi ara
        let missing_title = string::utf8(b"Rust");
        let missing_result = find_task_by_title(&board, missing_title);

        // Sonuc bos (is_none) olmali
        assert!(missing_result.is_none(), 2);
    }
     
}

