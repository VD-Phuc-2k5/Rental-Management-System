export class UserDTO {
    id!: string;
    email!: string;
    phone!: string;
    full_name!: string;
    avartar_url!: string | null;
    roles!: string[];
}