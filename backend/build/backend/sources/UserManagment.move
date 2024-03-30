module backend::UserManagment {
    use std::string::{Self, String};
    use std::option::{Self, Option};
    use sui::transfer;
    use sui::object::{Self, UID, ID};
    use sui::tx_context::{Self, TxContext};
    use sui::object_table::{Self, ObjectTable};
    use sui::event;

    const USER_ALREADY_CREATED: u64 = 0;
    const NOT_THE_OWNER: u64 = 1;

    struct User has key, store {
        id: UID, 
        firstName: String,
        lastName: String,
        dob: u64,
        owner: address,
        bio: Option<String>,
        phoneNumber: u64,
        email: String, 
        userName: String,
        userAddress: address,
        isActive: bool,
    }

    struct UserHub has key {
        id: UID, 
        owner: address,
        counter: u64,
        users: ObjectTable<address, User>,
    }

    struct UserCreated has copy, drop {
        id: ID,
        userName: String,
        userAddress: address,
    }

    struct BioUpdated has copy, drop {
        username: String,
        owner: address,
        bio: String,
    }

    fun init(_ctx: &mut TxContext){
        transfer::share_object(
            UserHub {
                id: object::new(_ctx),
                owner: tx_context::sender(_ctx),
                counter: 0,
                users: object_table::new(_ctx),
            }
        )
    }


    public entry fun create_user(firstname: vector<u8>, lastname: vector<u8>, 
    dob: u64,phonenumber: u64, email: vector<u8>, username: vector<u8>, userhub: &mut UserHub, _ctx: &mut TxContext){
        let potentialUser = object_table::borrow_mut(&mut userhub.users, tx_context::sender(_ctx));
        assert!(potentialUser.isActive == false, USER_ALREADY_CREATED);

        userhub.counter = userhub.counter + 1;
        let id = object::new(_ctx);
        
        event::emit(
            UserCreated {
                id: object::uid_to_inner(&id),
                userName: string::utf8(username),
                userAddress: tx_context::sender(_ctx),
            }
        );

        let newUser = User{
            id: id,
            firstName: string::utf8(firstname),
            lastName: string::utf8(lastname),
            dob: dob,
            owner: tx_context::sender(_ctx),
            bio: option::none(),
            phoneNumber: phonenumber,
            email: string::utf8(email),
            userName: string::utf8(username),
            userAddress: tx_context::sender(_ctx),
            isActive: true,
        };

        object_table::add(&mut userhub.users, tx_context::sender(_ctx), newUser);
    }

    public entry fun update_bio(userhub: &mut UserHub, new_bio: vector<u8>, _ctx: &mut TxContext){
        let user = object_table::borrow_mut(&mut userhub.users, tx_context::sender(_ctx));
        assert!(tx_context::sender(_ctx) == user.owner, NOT_THE_OWNER);

        let old_value = option::swap_or_fill(&mut user.bio, string::utf8(new_bio));

        event::emit(
            BioUpdated{
                username: user.userName,
                owner: tx_context::sender(_ctx),
                bio: string::utf8(new_bio)
            }
        );

        _ = old_value;
    }

    #[test_only]
    public fun init_for_testing(_ctx: &mut TxContext){
        init(_ctx);
    }

}