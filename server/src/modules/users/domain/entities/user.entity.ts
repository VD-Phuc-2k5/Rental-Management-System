export class UserEntity {
  constructor(
    public readonly id: string,
    public readonly phone: string | null,
    public readonly fullName: string,
    public readonly avatarUrl: string | null,
    public readonly role: RoleType[],
    public readonly createdAt: string,
    public readonly updatedAt: string,
    public readonly acceptedTerms: boolean,
  ) {}
}
