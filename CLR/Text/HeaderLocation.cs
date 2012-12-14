using System;
using System.Collections.Generic;
using System.Text;

namespace Dreamdb.ETL.Text
{
  /// <summary>
  /// States the supported type of source for the values of format fields in a TextRecordFormat.
  /// </summary>
  public enum HeaderLocation
  {
    /// <summary>
    /// The format does not incorporate common fields.
    /// </summary>
    None = 0,

    /// <summary>
    /// Format field values are encoded in file names.
    /// </summary>
    FileName,

    /// <summary>
    /// Format field values are encoded in file paths.
    /// </summary>
    FilePath,

    /// <summary>
    /// Format field values are contained in a header.
    /// </summary>
    SourceText

  }
}
