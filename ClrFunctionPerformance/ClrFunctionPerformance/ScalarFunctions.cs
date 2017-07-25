using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;

public partial class UserDefinedFunctions
{
    [Microsoft.SqlServer.Server.SqlFunction]
    public static int ConstantFunc()
    {
        return 0;
    }

    [Microsoft.SqlServer.Server.SqlFunction(DataAccess = DataAccessKind.Read)]
    public static int DataAccessFunc(int orderId)
    {
        using (SqlConnection connection = new SqlConnection("context connection=true"))
        {
            connection.Open();
            string sql = @"select top 1 ProductId from dbo.OrderDetail od where od.OrderId = @OrderId order by OrderDetailId;";
            using (SqlCommand command = new SqlCommand(sql, connection))
            {
                command.Parameters.Add(new SqlParameter("@OrderId", orderId));
                int count = (int)command.ExecuteScalar();
                return count;
            }
        }
    }
}
