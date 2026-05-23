export class ContractMemberEntity {
  constructor(
    public readonly id: string,
    public readonly contractId: string,
    public readonly fullName: string,
    public readonly phone: string | null,
    public readonly identityNumber: string | null,
    public readonly email: string | null,
    public readonly address: string | null,
    public readonly isRoomLeader: boolean,
    public readonly leftAt: Date | null,
    public readonly createdAt: Date,
    public readonly updatedAt: Date,
  ) {}
}
