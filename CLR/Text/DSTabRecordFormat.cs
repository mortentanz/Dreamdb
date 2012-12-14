#region Sourcesafe version
// $Archive: /CLR.root/CLR/Text/DSTabRecordFormat.cs $
// $Author: mls $
// $Revision: 1 $
// $Date: 12/18/06 15:48 $
// $Workfile: DSTabRecordFormat.cs $
// $Modtime: 9/28/06 15:49 $
#endregion

using System;
using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;

namespace Dreamdb.ETL.Text
{
  public sealed class DSTabRecordFormat : TextRecordFormat
  {
    public DSTabRecordFormat() : base()
    {
      StringBuilder sb = new StringBuilder();
      sb.Append(@"(?<contentcode>FODT|DODE|UDVA|INDV|MOAR|BEFA)\.TAB");
      sb.Append(@"(?<year>\d\d)\d?\.");
      sb.Append(@"(?<origincode>[A-Z]+)\.TXT");
      m_headerrex = new Regex(sb.ToString(), RegexOptions.IgnoreCase);
      m_headerlocation = HeaderLocation.FileName;

      sb = new StringBuilder();
      sb.Append(@"^\s*(?<age>\d+)\s*;");
      sb.Append(@"\s*(?<male>\d+)\s*;");
      sb.Append(@"\s*(?<female>\d+)\s*;");
      sb.Append(@"\s*(?<total>\d+)\s*;");
      m_recordrex = new Regex(sb.ToString(), RegexOptions.Multiline);

      m_fields.Add("contentcode", true);
      m_fields.Add("origincode", true);
      m_fields.Add("year", true);
      m_fields.Add("age");
      m_fields.Add("male");
      m_fields.Add("female");
      m_fields.Add("total");
    }

    public override TextRecordReader CreateReader(TextRecordParser parser)
    {
      return new DSTabRecordReader(parser);
    }

  }
}
