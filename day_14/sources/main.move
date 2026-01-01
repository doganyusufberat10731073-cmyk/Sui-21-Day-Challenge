/// DAY 14: Tests for Bounty Board

module challenge::day_14 {
    use std::string::{Self, String};
    

    // Copy from day_13: All structs and functions
    public enum TaskStatus has copy, drop, store {
        Open,
        Completed,
    }

    public struct Task has copy, drop, store {
        title: String,
        reward: u64,
        status: TaskStatus,
    }
    use std::vector::push_back;

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

    // Helper: Byte dizisinden Task olusturma
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

    public fun complete_task(board: &mut TaskBoard, index: u64) {
        let task = board.tasks.borrow_mut(index);
        task.status = TaskStatus::Completed;

    }
    
    // Analiz fonksiyonlari
    public fun total_reward(board: &TaskBoard): u64 {
        let len = board.tasks.length();
        let mut i = 0;
        let mut sum = 0;

        while (i < len) {
            let task = board.tasks.borrow(i);
            sum = sum + task.reward;
            i = i + 1;
        };
        sum
    }

    public fun completed_count(board: &TaskBoard): u64 {
        let len = board.tasks.length();
        let mut i = 0;
        let mut count = 0;

        while (i < len) {
            let task = board.tasks.borrow(i);
            if (task.status == TaskStatus::Completed) {
                count = count + 1;
            };
            i = i + 1;
        };
        count
    }

    // Testler

    // Testt 1: Pano olusturma ve ekleme
    #[test]
    fun test_create_board_and_add() {
        let owner = @0x1;
        let mut board = new_board(owner);

        // 1 Gorev ekle
        add_task(&mut board, create_task(b"Bug Fix", 100));

        // Uzunluk 1 mi?
        assert!(board.tasks.length() == 1, 0);

    }

    // Test 2: Tamamla ve sayac testi
    #[test]
    fun test_complete_flow() {
        let owner = @0x1;
        let mut board = new_board(owner);

        // 2 Gorev ekle
        add_task(&mut board, create_task(b"Gorev 1", 50));
        add_task(&mut board, create_task(b"Gorev 2", 100));

        // Ilk gorevi tamamla
        complete_task(&mut board, 0);

        // Tamamlanan sayisi 1 mi?
        assert!(completed_count(&board) == 1, 1);



    }

    // Test 3: Matematik testi (Toplam odul)
    #[test]
    fun test_calc_rewards() {
        let owner = @0x1;
        let mut board = new_board(owner);

        // 3 Farkli gorev ekle
        add_task(&mut board, create_task(b"T1", 50));
        add_task(&mut board, create_task(b"T2", 100));
        add_task(&mut board, create_task(b"T3", 25));

        // Hesap: 50 + 100 + 25 + = 175
        let total = total_reward(&board);
        assert!(total == 175, 2);


    }

    

    
}

