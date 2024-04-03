module backend::UserManagment {
    use std::string::{Self, String};
    use std::option::{Self, Option};
    use sui::transfer;
    use sui::url::{Self, Url};
    use sui::object::{Self, UID, ID};
    use sui::tx_context::{Self, TxContext};
    use sui::object_table::{Self, ObjectTable};
    use sui::event;

    const USER_ALREADY_CREATED: u64 = 0;
    const NOT_THE_OWNER: u64 = 1;

    struct Listing has key, store {
        id: UID,
        picture: Url,
        owner: address,
        description: String, 
        category: String, 
        brand: String,
        condition: String,
        price: u64,
    }

    struct User has key, store {
        id: UID, 
        firstName: String,
        lastName: String,
        dob: u64,
        bio: Option<String>,
        phoneNumber: u64,
        email: String, 
        userName: String,
        userAddress: address,
        isActive: bool,
        listings: ObjectTable<u64, Listing>,
    }

    struct UserHub has key {
        id: UID, 
        owner: address,
        counter: u64,
        users: ObjectTable<address, User>,
    }

    struct ListingCreated has copy, drop {
        id: ID,
        owner: address,
        brand: String,
        price: u64,
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

    public entry fun create_user(firstname: vector<u8>, lastname: vector<u8>, dob: u64, phonenumber: u64, 
                    email: vector<u8>, username: vector<u8>, userhub: &mut UserHub, _ctx: &mut TxContext){
       
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
            bio: option::none(),
            phoneNumber: phonenumber,
            email: string::utf8(email),
            userName: string::utf8(username),
            userAddress: tx_context::sender(_ctx),
            isActive: true,
            listings: object_table::new(_ctx)
        };

        object_table::add(&mut userhub.users, tx_context::sender(_ctx), newUser);
    }

     public entry fun create_listing(picture: vector<u8>, description: vector<u8>, category:vector<u8>, brand:vector<u8>,
                                         condition:vector<u8>, price: u64, userhub: &mut UserHub, _ctx: &mut TxContext) {

        let user = object_table::borrow_mut(&mut userhub.users, tx_context::sender(_ctx));                                                                                     
        let id = object::new(_ctx);

        event::emit(
            ListingCreated{
                id: object::uid_to_inner(&id),
                owner: tx_context::sender(_ctx),
                brand: string::utf8(brand),
                price: price,
            }
        );

       userhub.counter = userhub.counter + 1;

        let newListing = Listing{
            id: id,
            picture: url::new_unsafe_from_bytes(picture),
            owner: tx_context::sender(_ctx),
            description: string::utf8(description),
            category: string::utf8(category),
            brand: string::utf8(brand),
            condition: string::utf8(condition),
            price: price,
        };

        object_table::add(&mut user.listings,  userhub.counter, newListing );
    }

    public fun get_user(userhub: &UserHub, useraddress: address): (String, String, u64, Option<String>, u64, String, String, address, bool){
         let user: &User = object_table::borrow(&userhub.users, useraddress);
        (
            user.firstName,
            user.lastName,
            user.dob,
            user.bio,
            user.phoneNumber,
            user.email,
            user.userName,
            user.userAddress,
            user.isActive
        )
    }

    public entry fun update_bio(userhub: &mut UserHub, new_bio: vector<u8>, _ctx: &mut TxContext){
        let user = object_table::borrow_mut(&mut userhub.users, tx_context::sender(_ctx));
        assert!(tx_context::sender(_ctx) == user.userAddress, NOT_THE_OWNER);

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

    public fun getOwner(userhub: &UserHub): address {
        userhub.owner
    }

    public fun get_users(userhub: &UserHub, useraddress: address): &User{
        let user: &User = object_table::borrow(&userhub.users, useraddress);
        user
    }

    public fun get_users_own(userhub: &mut UserHub, useradddress: address): &mut User {
        let user: &mut User = object_table::borrow_mut(&mut userhub.users, useradddress);
        user
    }

    public fun get_user_listings(user: &User, id: u64): &Listing{
        let listing: &Listing = object_table::borrow(&user.listings, id);
        listing
    }

    public fun is_user_active(user: &User): bool {
        user.isActive
    }

    public fun get_listing_price(listing: &Listing):u64 {
        listing.price
    }
}


