USE bbpet;
GO

declare @SuccessOrder TABLE (
                                orderId INT
                            )

insert into @SuccessOrder(orderId)
select O.id as orderId
from [Order] O
where status = 'SUCCESS';

update O
SET O.status = 'PENDING'
from [Order] O
where O.status = 'SUCCESS';

update O
set O.status = 'SUCCESS'
from @SuccessOrder S
         left join [Order] O on O.id = S.orderId;