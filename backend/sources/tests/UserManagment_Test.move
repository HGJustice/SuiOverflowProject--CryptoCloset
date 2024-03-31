#[test_only]
module backend::UserManagment_Test{
    use sui::test_scenario;
    use sui::object_table::{Self, ObjectTable};
    use backend::UserManagment::{Self, User, UserHub};

    #[test]
    fun test_crate(){
        let owner = @0xA;
        let addy1 = @0xB;
        let addy2 = @0xC;

        let scenario_val = test_scenario::begin(owner);
        let scenario = &mut scenario_val;

        test_scenario::next_tx(scenario, owner);
        {
            UserManagment::init_for_testing(test_scenario::ctx(scenario))
        };

        test_scenario::next_tx(scenario, owner);
        {
           let userhub_val = test_scenario::take_shared<UserManagment::UserHub>(scenario);
           let userhub = &mut userhub_val;
           assert!(UserManagment::getOwner(userhub) == owner, 0); 
           test_scenario::return_shared(userhub_val);
        };

        test_scenario::next_tx(scenario, owner);
        {
           let userhub = test_scenario::take_shared<UserManagment::UserHub>(scenario); 
          
           UserManagment::create_user(b"kris", b"taylor", 031084, 902893, b"hei@l.de", b"bully", &mut userhub, test_scenario::ctx(scenario));
           assert!(test_scenario::has_most_recent_for_sender<User>(scenario), 0);
          

           test_scenario::return_shared(userhub);
        };

        test_scenario::end(scenario_val);
    }
}