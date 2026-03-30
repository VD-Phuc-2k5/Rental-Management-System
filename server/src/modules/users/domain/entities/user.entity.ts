export class UserEntity {
  constructor(
    public readonly id: string,
    public readonly phone: string,
    public readonly fullName: string,
    public readonly avatarUrl: string | null,
    public readonly createdAt: string,
    public readonly updatedAt: string,
  ) {}
}
