using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.Text;
using Microsoft.SqlServer.Server;

namespace Dreamdb.Demographics.Programmability
{
  public partial class StoredProcedures
  {

    /// <summary>
    /// Calculates reamining life time given a mortality estimation.
    /// </summary>
    /// <param name="estimationid">Database ID of a mortality estimation for which to calculate remaining life time.</param>
    /// <param name="maleinfantsurvival">Rate of non-instantaneous male infant deaths.</param>
    /// <param name="femaleinfantsurvival">Rate of non-instantaneous female infant deaths.</param>
    /// <param name="maxage">Upper bound on age for which to calculate remaining life time.</param>
    [Microsoft.SqlServer.Server.SqlProcedure]
    public static void uspGetRemainingLifeTime(
      SqlInt16 id,
      SqlBoolean estimation,
      SqlDouble maleinfantsurvival,
      SqlDouble femaleinfantsurvival,
      SqlByte maxage
    )
    {

      double sm = maleinfantsurvival.IsNull ? 0.111 : maleinfantsurvival.Value;
      double sf = femaleinfantsurvival.IsNull ? 0.112 : femaleinfantsurvival.Value;
      byte amax = maxage.IsNull ? (byte)120 : maxage.Value;

      StringBuilder cmdText = new StringBuilder();
      cmdText.Append("SELECT OriginID, GenderID, Age, Year, Estimate ");
      if (estimation.Value)
      {
        cmdText.Append("FROM Demographics.vMortalityMedio ");
        cmdText.Append("WHERE EstimationID = @id AND Age <= @maxage ");
      }
      else
      {
        cmdText.Append("FROM Demographics.ForecastedMortality ");
        cmdText.Append("WHERE ForecastID = @id AND Age <= @maxage ");
      }
      cmdText.Append("ORDER BY Year, OriginID, GenderID, Age DESC");

      SqlCommand cmd = new SqlCommand(cmdText.ToString());
      cmd.CommandType = CommandType.Text;
      cmd.Parameters.AddWithValue("@id", id.Value).Direction = ParameterDirection.Input;
      cmd.Parameters.AddWithValue("@maxage", amax).Direction = ParameterDirection.Input;

      SqlMetaData[] columns = {
        new SqlMetaData("OriginID", SqlDbType.TinyInt),
        new SqlMetaData("GenderID", SqlDbType.TinyInt),
        new SqlMetaData("Age", SqlDbType.TinyInt),
        new SqlMetaData("Year", SqlDbType.SmallInt),
        new SqlMetaData("ExpectedLifeTime", SqlDbType.Float)
      };
      SqlDataRecord record = new SqlDataRecord(columns);
      
      double l = 0.5;
      using (SqlConnection conn = new SqlConnection("context connection=true"))
      {
        cmd.Connection = conn;
        conn.Open();
        SqlDataReader r = cmd.ExecuteReader();
        SqlContext.Pipe.SendResultsStart(record);
        while (r.Read())
        {
          byte g = r.GetByte(1);
          byte a = r.GetByte(2);
          double m = r.GetDouble(4);

          if (a == amax)
          {
            l = 0.5;
          }
          else if (a > 0)
          {
            l = 0.5 * m + (1 - m) * (1 + l);
          }
          else
          {
            l = ((g == 0) ? sm : sf) * m + (1 - m) * (1 + l);
          }

          record.SetByte(0, r.GetByte(0));
          record.SetByte(1, g);
          record.SetByte(2, a);
          record.SetInt16(3, r.GetInt16(3));
          record.SetDouble(4, l);
          SqlContext.Pipe.SendResultsRow(record);
        }
        r.Close();
        conn.Close();
        SqlContext.Pipe.SendResultsEnd();
      }
    }
  };
}